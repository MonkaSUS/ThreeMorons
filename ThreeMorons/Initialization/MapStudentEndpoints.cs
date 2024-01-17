﻿namespace ThreeMorons.Initialization
{
    public static partial class Initializer
    {
        public static void MapStudentEndpoints(WebApplication app)
        {
            var StudentGroup = app.MapGroup("/student").RequireAuthorization();
            StudentGroup.MapGet("", async (ThreeMoronsContext db) => await db.Students.ToListAsync());
            StudentGroup.MapGet("", async ([FromQuery(Name = "id")] string studId, ThreeMoronsContext db) => await db.Students.FindAsync(studId));
            StudentGroup.MapPost("", async (StudentInput inp, ThreeMoronsContext db) =>
            {
                try
                {
                    Student StudentToCreate = new()
                    {
                        StudNumber = inp.StudNumber,
                        GroupName = inp.GroupName,
                        Name = inp.Name,
                        Surname = inp.Surname,
                        Patronymic = inp.Patronymic,
                        PhoneNumber = inp.PhoneNumber,
                    };
                    await db.Students.AddAsync(StudentToCreate);
                    await db.SaveChangesAsync();
                    return Results.Created("/student", StudentToCreate);
                }
                catch (Exception exc)
                {
                    return Results.Problem(exc.ToString());
                }
            });
            StudentGroup.MapPut("", async (StudentInput inp, ThreeMoronsContext db) =>
            {
                try //12 часов ночи, я знаю, что можно сделать элегантнее. оставлю так до первого рефакторинга
                {
                    var StudentToUpdate = await db.Students.FindAsync(inp.StudNumber);
                    StudentToUpdate.Name = inp.Name;
                    StudentToUpdate.Surname = inp.Surname;
                    StudentToUpdate.PhoneNumber = inp.PhoneNumber;
                    db.Students.Update(StudentToUpdate);
                    await db.SaveChangesAsync();
                    return Results.Ok();
                }
                catch (Exception exc)
                {
                    return Results.Problem(exc.ToString());
                }
            });
            //ОТЧИСЛЯЕМ ПИДОРАСА
            StudentGroup.MapDelete("", async ([FromQuery(Name = "studNumber")] string StudNumber, ThreeMoronsContext db) =>
            {
                try
                {
                    //ТЕБЕ НЕ СБЕЖАТЬ
                    var StudentToDelete = await db.Students.FindAsync(StudNumber);
                    //ПОЛУУЧАЙ СУКА
                    db.Students.Remove(StudentToDelete);

                    await db.SaveChangesAsync();
                    return Results.Ok(); //ВСЁ ПРОСТО ЗАЕБИСЬ ОК
                }
                catch (Exception exc)
                {
                    return Results.Problem(exc.ToString()); //ахуеть мы даже отчислить человека не можем нормально
                }

            });

        }
    }
}