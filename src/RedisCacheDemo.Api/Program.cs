using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Distributed;

internal class Program
{
    private static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.
        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();

        builder.Services.AddStackExchangeRedisCache(options =>
         {
             options.Configuration = builder.Configuration.GetValue<string>("REDIS_CONNECTION_STRING");
             options.InstanceName = "SampleInstance";
         });

        var app = builder.Build();

        // // Configure the HTTP request pipeline.
        // if (app.Environment.IsDevelopment())
        // {
        //     app.UseSwagger();
        //     app.UseSwaggerUI();
        // }

        // app.UseHttpsRedirection();

        var summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        app.MapGet("/api/time", ([FromServices]IDistributedCache cache, [FromServices]ILogger<Program> logger) =>
        {
            var cacheKey = "CurrentUtcTime";

            var data = cache.GetString(cacheKey);

            if (string.IsNullOrEmpty(data))
            {
                logger.LogWarning("Cache Miss");
                data = $"{DateTime.UtcNow:s}";
                var options = new DistributedCacheEntryOptions
                { 
                    AbsoluteExpiration = DateTimeOffset.UtcNow.AddSeconds(30)
                };
                cache.SetString(cacheKey, data, options);
            } else
            {
                logger.LogInformation("Cache Hit");
            }

            return new { currentTime = data };
        })
        .WithName("GetCurrentTime")
        .WithOpenApi();

        app.Run();
    }
}
