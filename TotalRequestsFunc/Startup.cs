using Azure.Extensions.AspNetCore.Configuration.Secrets;
using Azure.Identity;
using Azure.Monitor.Query;
using Azure.Security.KeyVault.Secrets;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;

[assembly: FunctionsStartup(typeof(TotalRequestsFunc.Startup))]

namespace TotalRequestsFunc
{
    public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            var services = builder.Services;

            var configurationBuilder = new ConfigurationBuilder().AddEnvironmentVariables();

            var creds = new DefaultAzureCredential(new DefaultAzureCredentialOptions
            {
                VisualStudioCodeTenantId = Environment.GetEnvironmentVariable("AZURE_TENANT_ID"),
                SharedTokenCacheTenantId = Environment.GetEnvironmentVariable("AZURE_TENANT_ID")
            });

            var kvClient = new SecretClient(new Uri(Environment.GetEnvironmentVariable("KEYVAULT_URL")), creds);

            var logsQueryClient = new LogsQueryClient(creds);

            configurationBuilder.AddAzureKeyVault(kvClient, new AzureKeyVaultConfigurationOptions());

            var configuration = configurationBuilder.Build();

            services.AddApplicationInsightsTelemetry();
            services.AddSingleton(configuration);
            services.AddSingleton(logsQueryClient);
            services.AddHttpClient();

        }
    }
}
