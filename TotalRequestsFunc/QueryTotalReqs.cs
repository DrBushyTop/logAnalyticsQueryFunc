using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Azure;
using Azure.Monitor.Query;
using Azure.Monitor.Query.Models;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace TotalRequests
{
    public class TotalRequests
    {
        private readonly TelemetryClient telemetryClient;
        private readonly LogsQueryClient logsQueryClient;
        private readonly IConfiguration configuration;

        public TotalRequests(TelemetryConfiguration telemetryConfiguration, LogsQueryClient logsQueryClient, IConfiguration configuration)
        {
            this.telemetryClient = new TelemetryClient(telemetryConfiguration);
            this.logsQueryClient = logsQueryClient;
            this.configuration = configuration;
        }

        [FunctionName("TotalRequests")]
        //public void Run([TimerTrigger("0 */5 * * * *")]TimerInfo myTimer, ILogger log)
        public async Task<IActionResult> Run(
            [HttpTrigger("get", Route = "TotalRequests")]
            HttpRequest req, ILogger log)
        {
            log.LogInformation($"TotalRequests timer trigger function executed at: {DateTime.Now}");

            var workspaceId = configuration["WORKSPACE_ID"];
            var timespan = TimeSpan.FromDays(28);

            try
            {
                var numRequests = await GetTotalRequestsInTimeSpan(workspaceId, timespan);

                telemetryClient.TrackMetric($"numRequestsIn{timespan.Days}d", numRequests);

                return new OkObjectResult(numRequests);
            }
            catch (Exception ex)
            {
                telemetryClient.TrackException(ex);
                throw;
            }


        }

        private async Task<int> GetTotalRequestsInTimeSpan(string workspaceId, TimeSpan timeSpan)
        {
            var query = "AppRequests" +
            "| where ResultCode !in (400,401,403,404)" +
            "| summarize _count = sum(ItemCount)";

            Response<IReadOnlyList<int>> response = await logsQueryClient.QueryWorkspaceAsync<int>(
                workspaceId,
                query,
                new QueryTimeRange(timeSpan)
                );

            if (response.Value.Count != 1)
            {
                throw new Exception($"Query {query} returned {response.Value.Count} items instead of expected 1");
            }

            return response.Value[0];
        }
    }

}
