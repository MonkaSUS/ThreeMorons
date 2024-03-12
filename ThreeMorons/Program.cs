using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using OpenTelemetry.Metrics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using System.Diagnostics;
using System.Diagnostics.Metrics;
using System.Net;
using System.Text.Json;
using ThreeMorons.HealthCheck;
var builder = WebApplication.CreateBuilder(args); 
//���� ���������, ������ ��� ��������� ����������� ����� �Ш� ��� ���� ��� ���� ������
builder.Services.Configure<Microsoft.AspNetCore.Http.Json.JsonOptions>(o =>
{
    o.SerializerOptions.IncludeFields = true;
});
var otel = builder.Services.AddOpenTelemetry();

var TotalRequestMeter = new Meter("TotalRequestMeter", "1.0.0");
var countRequests = TotalRequestMeter.CreateCounter<int>("requests.count", description: "Counts the total number of request since the last restart of the server");
var TotalActivitySource = new ActivitySource("TotalRequestMeter");

otel.ConfigureResource(r => r.AddService(serviceName: builder.Environment.ApplicationName));
otel.WithMetrics(m => m
    .AddAspNetCoreInstrumentation()
    .AddMeter(TotalRequestMeter.Name)
    .AddMeter("Microsoft.AspNetCore.Hosting")
    .AddMeter("Microsoft.AspNetCore.Server.Kestrel")
    .AddPrometheusExporter());

otel.WithTracing(t =>
{
    t.AddAspNetCoreInstrumentation();
    t.AddHttpClientInstrumentation();
    t.AddOtlpExporter();
});



var app = Initializer.Initialize(builder);

app.Use(async (context, next) =>
{
    await next();
    using var activity = TotalActivitySource.StartActivity("RequestMeter");
    countRequests.Add(1);
    activity?.SetTag("request happened", context.GetEndpoint().ToString());
});
app.MapPrometheusScrapingEndpoint();
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}
//TODO ���� ����
app.UseHttpsRedirection();





app.MapGet("/", () => Results.Content("amogus"));

Initializer.MapGroupEndpoints(app);

app.MapGet("/periods", async (ThreeMoronsContext db) => await db.Periods.ToListAsync());
app.MapGet("/refresh", async(ThreeMoronsContext db, HttpContext c)=>
{
    c.Request.Headers.TryGetValue("Authorization", out var jwt);
    c.Request.Headers.TryGetValue("Refresh", out var rft);
    //����� ����� �������� �������� ������������� ����� ���� � ��
    //�����
    var iden = c.User.Identity as ClaimsIdentity;
    var id = iden.FindFirst("jti").Value;
    var uclass = iden.FindFirst("UserClass").Value;
    var newTokens = JwtIssuer.IssueJwtForUser(builder.Configuration, id, uclass);
    return Results.Ok(newTokens);

});

Initializer.MapSkippedClassEndpoints(app);

Initializer.MapStudentEndpoints(app);

Initializer.MapDelayEndpoints(app);

Initializer.MapUserEndpoints(app, builder);



app.UseAuthentication();
app.UseAuthorization();




app.Run();
