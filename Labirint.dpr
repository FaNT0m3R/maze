program Labirint;

uses
  Forms,
  LabUnit1 in 'LabUnit1.pas' {MainForm};
                        
{$R *.res}            
{$R smile.res}  //� ���� ����� ����� �������� ��������

begin            
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
