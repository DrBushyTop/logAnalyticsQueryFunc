using System;
using Azure.Monitor.Query;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace TotalRequests
{
    public class QueryTotalReqs
    {
        private readonly TelemetryClient telemetryClient;
        private readonly LogsQueryClient logsQueryClient;

        public QueryTotalReqs(TelemetryConfiguration telemetryConfiguration, LogsQueryClient logsQueryClient)
        {
            this.telemetryClient = new TelemetryClient(telemetryConfiguration);
            this.logsQueryClient = logsQueryClient;
        }

        [FunctionName("QueryTotalReqs")]
        public void Run([TimerTrigger("0 */5 * * * *")]TimerInfo myTimer, ILogger log)
        {
            log.LogInformation($"C# Timer trigger function executed at: {DateTime.Now}");
        }
    }

}
