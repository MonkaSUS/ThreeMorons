var builder = WebApplication.CreateBuilder(args);

var app = Initializer.Initialize(builder); 


if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}






app.MapGet("/", () => "���� �������� ������ �����, ������� �������� ����������� ������� �� ���������� ��");
app.MapPost("/register", [AllowAnonymous] async (IValidator<RegistrationInput> validator, RegistrationInput inp, ThreeMoronsContext db) =>
    {
        var valres = await validator.ValidateAsync(inp);
        if (!valres.IsValid)
        {
            return Results.ValidationProblem(valres.ToDictionary());
        }
        if (await db.Users.AnyAsync(x=> x.Login == inp.login))
        {
            return Results.Conflict("������������ � ����� ������� ��� ����������");
        }
        var HashingResult = PasswordMegaHasher.HashPass(inp.password);
        try
        {
            User UserToRegister = new()
            {
                Id = Guid.NewGuid(),
                Login = inp.login,
                Password = HashingResult.hashpass,
                Salt = HashingResult.salt,
                Name = inp.name,
                Surname = inp.surname,
                Patronymic = inp.patronymic,
                UserClassId = inp.UserClassId
            };
            await db.Users.AddAsync(UserToRegister);
            await db.SaveChangesAsync();
            return Results.Created("",UserToRegister);
        }
        catch (Exception exc)
        {
            return TypedResults.BadRequest(exc.Message);
        }
    });
app.MapPost("/authorizeTest", [AllowAnonymous] async (IValidator<AuthorizationInput> Validator, AuthorizationInput inp, ThreeMoronsContext db) =>
    {
        var valres = await Validator.ValidateAsync(inp);
        if (!valres.IsValid)
        {
            return Results.ValidationProblem(valres.ToDictionary());
        }
        User UserToAuthorizeInDb = await db.Users.FirstOrDefaultAsync(user => user.Login == inp.login);
        if (UserToAuthorizeInDb is  null)
        {
            return Results.Problem("������������ � ����� �����");
        }
        byte[] userSalt = UserToAuthorizeInDb.Salt;
        var hashedPassword = PasswordMegaHasher.HashPass(inp.password, userSalt);
        if (UserToAuthorizeInDb.Password != hashedPassword)
        {
            return Results.Unauthorized();
        }
        var stringToken = JwtIssuer.IssueJwtForUser(builder.Configuration, UserToAuthorizeInDb);
        return Results.Ok(stringToken);


    });


Initializer.MapGroupEndpoints(app);


app.MapGet("/periods", async (ThreeMoronsContext db) => await db.Periods.ToListAsync());

Initializer.MapSkippedClassEndpoints(app);

Initializer.MapStudentEndpoints(app);

Initializer.MapDelayEndpoints(app);








app.UseAuthentication();
app.UseAuthorization();

app.Run();
