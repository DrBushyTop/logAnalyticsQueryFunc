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
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace TotalRequests
{
    public class TestKeyVault
    {
        private readonly TelemetryClient telemetryClient;
        private readonly LogsQueryClient logsQueryClient;
        private readonly IConfiguration configuration;

        public TestKeyVault(TelemetryConfiguration telemetryConfiguration, LogsQueryClient logsQueryClient, IConfiguration configuration)
        {
            this.telemetryClient = new TelemetryClient(telemetryConfiguration);
            this.logsQueryClient = logsQueryClient;
            this.configuration = configuration;
        }

        [FunctionName("TestKeyVault")]
        public async Task<IActionResult> Run(
            [HttpTrigger("get", Route = "TestKeyVault")]
            HttpRequest req, ILogger log)
        {
            log.LogInformation("TestKeyVault-function triggered by HTTP Request.");

            var secretValue = configuration["mySecret"];

            return new OkObjectResult(secretValue);
        }
    }

}
