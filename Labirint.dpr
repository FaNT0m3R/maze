program Labirint;

uses
  Forms,
  LabUnit1 in 'LabUnit1.pas' {MainForm};
                        
{$R *.res}            
{$R smile.res}  //в этом файле лежит картинка смайлика

begin            
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
