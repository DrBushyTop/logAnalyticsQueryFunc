using System;
using System.IO;
using System.Threading.Tasks;
using System.Web.Http;
using Azure.Monitor.Query;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace TotalRequests
{
    public class GenerateExampleTraffic
    {
        private readonly TelemetryClient telemetryClient;
        private readonly LogsQueryClient logsQueryClient;

        public GenerateExampleTraffic(TelemetryConfiguration telemetryConfiguration, LogsQueryClient logsQueryClient)
        {
            this.telemetryClient = new TelemetryClient(telemetryConfiguration);
            this.logsQueryClient = logsQueryClient;
        }

        // For generating traffic to selected log analytics workspace.
        // Change instrumentation key to target App Insights, run below command when function running and then switch back
        // hey -m GET -c 100 -n 10000 http://localhost:7071/api/GenerateExampleTraffic

        [FunctionName("GenerateExampleTraffic")]
        public async Task<IActionResult> Run(
            [HttpTrigger("get", Route = "GenerateExampleTraffic")]
            HttpRequest req, ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            try
            {
                Random random = new();

                var rint = random.Next(3);

                return rint switch
                {
                    0 => new BadRequestObjectResult("Hit case 0. Failing with 400"),
                    1 => throw new Exception("Hit case 1, Throwing exception with 503"),
                    _ => new OkObjectResult("Default Reply, Success"),
                };
            }
            catch (Exception ex)
            {
                telemetryClient.TrackException(ex, null, null);
                throw;
            }
            
        }
    }

}
