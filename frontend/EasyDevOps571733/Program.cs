// See https://aka.ms/new-console-template for more information
using System;
using System.Diagnostics;

class Program
{
    static void Main()
    {
        // Print tekst
        Console.WriteLine("EasyDevOps");

        // Open logo.png vanuit Downloads
        string path = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile) 
                      + "/Downloads/logo.png";

        Process.Start(new ProcessStartInfo
        {
            FileName = path,
            UseShellExecute = true
        });
    }
}
