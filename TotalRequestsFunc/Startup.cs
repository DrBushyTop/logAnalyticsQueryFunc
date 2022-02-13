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

            var creds = new DefaultAzureCredential(new DefaultAzureCredentialOptions
            {
                VisualStudioCodeTenantId = Environment.GetEnvironmentVariable("AZURE_TENANT_ID"),
                SharedTokenCacheTenantId = Environment.GetEnvironmentVariable("AZURE_TENANT_ID")
            });


            var logsQueryClient = new LogsQueryClient(creds);

            services.AddSingleton(logsQueryClient);
            services.AddHttpClient();
        }

        public override void ConfigureAppConfiguration(IFunctionsConfigurationBuilder builder)
        {
            var creds = new DefaultAzureCredential(new DefaultAzureCredentialOptions
            {
                VisualStudioCodeTenantId = Environment.GetEnvironmentVariable("AZURE_TENANT_ID"),
                SharedTokenCacheTenantId = Environment.GetEnvironmentVariable("AZURE_TENANT_ID")
            });

            var kvClient = new SecretClient(new Uri(Environment.GetEnvironmentVariable("KEYVAULT_URL")), creds);

            builder.ConfigurationBuilder
                .AddEnvironmentVariables()
                .AddAzureKeyVault(kvClient, new AzureKeyVaultConfigurationOptions());
        }
    }
}
