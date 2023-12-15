﻿using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using System.ComponentModel.DataAnnotations;
using System.Security.Cryptography;

namespace ThreeMorons
{
    public static class PasswordMegaHasher
    {
        public static (string hashpass, string salt) HashPass(string inp)
        {
            byte[] salt = RandomNumberGenerator.GetBytes(128 / 8);
            string StringSalt = salt.ToString();
            string hashed = Convert.ToBase64String(KeyDerivation.Pbkdf2(
                password: inp,
                salt: salt,
                prf: KeyDerivationPrf.HMACSHA256,
                iterationCount: 100000,
                numBytesRequested: 256 / 8));
            return (hashed, StringSalt);
        }
    }
    /// <summary>
    /// Рекорд, содержащий все поля, необходимые для регистрации нового пользователя и соответствующую валидацию для них.
    /// </summary>
    public record RegistrationInput(string login, string password, string name, string surname, string patronymic, int UserClassId)
    { }
    
}