using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

namespace ActualizadorEset
{
    public class MainForm : Form
    {
        private Button btnActualizar;
        private TextBox txtOutput;
        private string sevenZipPath = @".\7z\";
        private string sfxPath = @".\sfx\";
        private string destinationPath = @"D:\APLICACIONES\ANTIVIRUS\ESET\Actualizacion\";

        public MainForm()
        {
            this.btnActualizar = new Button
            {
                Text = "Actualizar Eset",
                Location = new System.Drawing.Point(10, 10),
                Size = new System.Drawing.Size(100, 30)
            };
            this.btnActualizar.Click += new EventHandler(this.BtnActualizar_Click);

            this.txtOutput = new TextBox
            {
                Location = new System.Drawing.Point(10, 50),
                Size = new System.Drawing.Size(280, 200),
                Multiline = true,
                ScrollBars = ScrollBars.Vertical,
                ReadOnly = true
            };

            this.Controls.Add(this.btnActualizar);
            this.Controls.Add(this.txtOutput);
        }

        private void BtnActualizar_Click(object sender, EventArgs e)
        {
            try
            {
                // Eliminar archivos antiguos
                EliminarArchivos(sevenZipPath + "nod.7z");
                EliminarArchivos(sfxPath + "*.exe");

                // Comprimir archivos
                ComprimirArchivos(sevenZipPath, "nod.7z", "@source.txt");

                // Crear ejecutables
                CrearEjecutables(sevenZipPath, sfxPath, "nod.7z", "eset_update.exe", "script.txt");
                CrearEjecutables(sevenZipPath, sfxPath, "nod.7z", "eset_update_m.exe", "script_m.txt");

                // Copiar a la carpeta de destino
                CopiarADestino(sfxPath + "eset_update.exe", destinationPath + "eset_update.exe");

                txtOutput.AppendText("Proceso completado.\r\n");
            }
            catch (Exception ex)
            {
                txtOutput.AppendText("Error: " + ex.Message + "\r\n");
            }
        }

        private void EliminarArchivos(string path)
        {
            if (File.Exists(path))
            {
                File.Delete(path);
                txtOutput.AppendText("Eliminado: " + path + "\r\n");
            }
        }

        private void ComprimirArchivos(string directory, string archiveName, string fileList)
        {
            ProcessStartInfo psi = new ProcessStartInfo
            {
                FileName = "7z.exe",
                Arguments = $"a -t7z \"{archiveName}\" {fileList} -r -mx0",
                WorkingDirectory = directory,
                CreateNoWindow = true,
                UseShellExecute = false,
                RedirectStandardOutput = true
            };

            using (Process p = Process.Start(psi))
            {
                p.WaitForExit();
                txtOutput.AppendText(p.StandardOutput.ReadToEnd());
            }
        }

        private void CrearEjecutables(string sevenZipPath, string sfxPath, string archiveName, string executableName, string scriptName)
        {
            string command = $"/C copy /b \"7zsd_All.sfx\" + \"{scriptName}\" + \"{archiveName}\" \"{sfxPath}{executableName}\"";
            ExecuteCommand(command, sevenZipPath);
        }

        private void CopiarADestino(string source, string destination)
        {
            File.Copy(source, destination, true);
            txtOutput.AppendText("Copiado a: " + destination + "\r\n");
        }

        private void ExecuteCommand(string command, string workingDirectory)
        {
            ProcessStartInfo psi = new ProcessStartInfo
            {
                FileName = "cmd.exe",
                Arguments = command,
                WorkingDirectory = workingDirectory,
                CreateNoWindow = true,
                UseShellExecute = false,
                RedirectStandardOutput = true
            };

            using (Process p = Process.Start(psi))
            {
                p.WaitForExit();
                txtOutput.AppendText(p.StandardOutput.ReadToEnd());
            }
        }

        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }
}
