var builder = WebApplication.CreateBuilder(args);

var app = Initializer.Initialize(builder); 

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

app.MapGet("/", () => "���� �������� ������ �����, ������� �������� ����������� ������� �� ���������� ��");


Initializer.MapGroupEndpoints(app);

app.MapGet("/periods", async (ThreeMoronsContext db) => await db.Periods.ToListAsync());

Initializer.MapSkippedClassEndpoints(app);

Initializer.MapStudentEndpoints(app);

Initializer.MapDelayEndpoints(app);

Initializer.MapUserEndpoints(app, builder);



app.UseAuthentication();
app.UseAuthorization();

app.Run();
