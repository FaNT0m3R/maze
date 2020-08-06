unit LabUnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ValEdit;

const T = True;     //��� �������� ����������� ������� ��� �������� �����
      F = False;
      CL_FINISH = $aaaaff;  //���� �������� ������
type

  TMainForm = class(TForm)
    lblTime: TLabel;
    imgWorkField: TImage;
    butStart: TButton;
    butStop: TButton;
    MainTimer: TTimer;
    lbNames: TListBox;
    lbTimes: TListBox;
    Edit1: TEdit;
    Label1: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure butStartClick(Sender: TObject);
    procedure butStopClick(Sender: TObject);
    procedure MainTimerTimer(Sender: TObject);
    procedure DrawLabirint();
    procedure AddRecord(sName,sTime:string);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  MainForm: TMainForm;
  bGameStat: Boolean;                        //�������� �� ����
  sGameTime: string[7] = '00:00.0';        //� ���� ������ �������� �����
  Player:TPoint;                      //��� ��������� ������
  bmpSmile: TBitmap;                   //��� �������� �������� ������
  fRec:Text;                           //��������� ����������

{���� ���� �������� 2�2 ������, �� ����� �� ������ ������ �� 3 ������������ ������
� �� ������ ������� �� 3 ��������������.}
  MapVert: array[1..20,0..20]
        of Boolean = ((T,T,F,T,T,F,T,T,F,T,F,F,F,T,F,T,F,F,F,F,T),
                      (T,F,T,T,F,T,T,F,T,T,T,F,F,T,T,T,T,F,T,F,T),
                      (T,T,T,T,F,F,T,T,F,T,F,T,T,F,T,T,F,T,F,T,T),
                      (T,T,T,F,F,F,F,T,T,T,F,F,T,T,F,F,F,F,T,T,T),
                      (T,T,F,T,T,F,T,F,F,F,T,F,F,F,T,F,F,F,T,T,T),
                      (T,F,T,F,F,T,F,T,F,T,F,F,T,F,F,T,F,T,F,F,T),
                      (T,T,F,F,T,T,T,F,T,F,T,T,T,T,F,F,T,F,F,F,T),
                      (T,T,F,F,T,T,F,F,F,F,F,T,F,T,T,F,T,F,F,F,T),
                      (T,F,T,T,T,T,F,T,T,F,T,F,T,F,F,F,F,F,F,T,T),
                      (T,T,F,T,T,F,T,T,T,T,F,F,F,T,F,F,F,F,T,T,T),
                      (T,T,T,F,T,T,T,F,F,F,F,F,F,F,T,F,F,T,T,F,T),
                      (T,T,T,F,F,T,T,F,F,F,F,F,F,T,T,T,F,F,F,F,T),
                      (T,F,F,T,F,F,F,F,T,T,F,F,T,F,T,F,T,T,F,F,T),
                      (T,F,T,F,T,F,T,T,F,T,F,T,T,T,F,T,T,F,F,F,T),
                      (T,T,F,T,F,T,F,T,F,F,T,F,T,F,F,T,F,T,F,T,T),
                      (T,F,F,T,T,F,T,F,F,F,T,T,F,F,F,F,T,F,T,F,T),
                      (T,T,T,F,F,T,F,F,T,F,F,F,T,T,F,F,F,F,F,F,T),
                      (T,T,T,T,T,F,F,F,T,F,F,T,F,T,F,T,T,F,F,F,T),
                      (T,T,F,T,T,F,F,T,F,F,T,F,T,T,F,F,F,T,F,T,T),
                      (T,F,F,F,F,F,F,F,F,F,F,T,F,F,T,F,F,F,F,F,T));

  MapHoriz: array[0..20,1..20]
        of Boolean = ((T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T),
                      (F,T,F,F,T,F,F,T,F,F,T,T,F,F,T,F,T,F,T,T),
                      (F,F,F,F,T,F,F,T,F,F,T,F,T,F,F,F,T,F,T,F),
                      (T,F,F,T,T,F,F,F,F,F,T,F,F,T,F,T,F,T,F,F),
                      (F,F,T,F,T,T,F,T,F,F,T,T,F,F,T,T,T,F,F,F),
                      (F,F,F,T,T,F,T,T,F,T,T,T,F,T,F,T,T,F,F,F),
                      (F,F,T,T,F,F,F,F,T,F,T,F,F,F,T,F,F,T,T,T),
                      (F,T,T,F,F,F,T,T,F,T,F,F,F,F,T,T,F,T,T,T),
                      (T,F,T,F,F,T,T,F,F,F,F,F,F,T,F,T,F,T,T,F),
                      (F,T,F,F,F,T,F,F,F,F,T,T,F,T,T,T,T,T,F,F),
                      (F,F,F,F,F,F,F,T,F,T,T,F,T,F,T,T,T,F,F,F),
                      (F,F,T,T,F,F,F,T,T,T,F,T,T,F,F,T,F,F,T,T),
                      (F,T,F,T,T,F,T,T,F,T,T,T,F,F,F,T,T,T,T,F),
                      (T,T,F,T,F,T,F,T,F,F,F,T,F,T,T,F,F,T,T,T),
                      (F,T,F,T,T,F,F,F,T,T,F,F,F,T,F,F,F,T,T,F),
                      (F,T,F,F,T,F,T,T,T,F,F,F,T,T,F,T,F,T,F,F),
                      (F,F,F,F,T,F,F,T,T,T,F,T,F,T,T,T,F,T,T,T),
                      (F,F,T,F,F,T,T,T,F,T,T,F,F,F,T,F,T,T,F,T),
                      (F,F,F,F,T,T,T,F,F,F,F,T,F,T,F,F,F,T,T,F),
                      (F,T,T,T,F,F,F,T,T,T,T,F,T,F,T,T,T,F,T,F),
                      (T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T,T));


implementation

{$R *.dfm}

procedure TMainForm.DrawLabirint();     //�� �������� MapVert � MapHoriz
var i,j:Integer;                         //������ ��������
begin
  imgWorkField.Canvas.Pen.Color:=clBlack;
  for j:=0 to 20 do                         //������� ������ ������������ ������
    for i:=1 to 20 do
      if MapVert[i,j] then
      begin
        imgWorkField.Canvas.MoveTo(j*20,i*20-20);
        imgWorkField.Canvas.LineTo(j*20,i*20+1);
      end;

  for i:=0 to 20 do                           //����� ������������
    for j:=1 to 20 do
      if MapHoriz[i,j] then
      begin
        imgWorkField.Canvas.MoveTo(j*20-20,i*20);
        imgWorkField.Canvas.LineTo(j*20+1,i*20);
      end;

  imgWorkField.Canvas.Brush.Color:=CL_FINISH;    //������������� ���� ��� �������� ������
  imgWorkField.Canvas.Pen.Color:=CL_FINISH;     //� �����, � ���� �����, ��� �� �� ���� ����� ����� ��������
  imgWorkField.Canvas.Rectangle((20-1)*20+1,(20-1)*20+1,
                               (20-1)*20+20,(20-1)*20+20);//�� �������� ������ ������ �������
end;

procedure TMainForm.AddRecord(sName,sTime:string);
var i:Integer;
begin
  i:=0;
  while (i<lbNames.Items.Count) and       //���� ������ ������ �� ��������, �������
        (sTime > lbTimes.Items[i]) do     //������ �������� �������
     inc(i);

  lbTimes.Items.Insert(i,sTime);       //� ��������� ������ ���������� ���������
  lbNames.Items.Insert(i,sName);
  lbTimes.Selected[i]:=True;          //�������� ����� ������
  lbNames.Selected[i]:=True;
end;



//��� ������� ���������� ��� ������� �� ������� � ������� �����
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if bGameStat then
  begin
    imgWorkField.Canvas.Pen.Color:=clWhite;    //��� ��� ���� �������� ������ �����
    imgWorkField.Canvas.Brush.Color:=clWhite;  //�� ������������� ����� ����
    case Key of                             //� ����������� �� ������� ������ ������ ����������
    VK_DOWN:                                //� Player, ������ ���� ������� � ������ ������ � ������ ����� � �����
        begin
          if not MapHoriz[Player.Y,Player.X] then
          begin
            imgWorkField.Canvas.Rectangle((Player.X-1)*20+1,(Player.Y-1)*20+1,
                                         (Player.X-1)*20+20,(Player.Y-1)*20+20);
            inc(Player.Y);
            imgWorkField.Canvas.Draw((Player.X-1)*20+1,(Player.Y-1)*20+1,bmpSmile);
          end;
        end;
    VK_UP:
        begin
          if not MapHoriz[Player.Y-1,Player.X] then
          begin
            imgWorkField.Canvas.Rectangle((Player.X-1)*20+1,(Player.Y-1)*20+1,
                                        (Player.X-1)*20+20,(Player.Y-1)*20+20);
            dec(Player.Y);
            imgWorkField.Canvas.Draw((Player.X-1)*20+1,(Player.Y-1)*20+1,bmpSmile);
          end;
        end;
    VK_RIGHT:
        begin
          if not MapVert[Player.Y,Player.X] then
          begin
            imgWorkField.Canvas.Rectangle((Player.X-1)*20+1,(Player.Y-1)*20+1,
                                    (Player.X-1)*20+20,(Player.Y-1)*20+20);
            inc(Player.X);
            imgWorkField.Canvas.Draw((Player.X-1)*20+1,(Player.Y-1)*20+1,bmpSmile);
          end;
        end;
    VK_LEFT:
        begin
          if not MapVert[Player.Y,Player.X-1] then
          begin
            imgWorkField.Canvas.Rectangle((Player.X-1)*20+1,(Player.Y-1)*20+1,
                                    (Player.X-1)*20+20,(Player.Y-1)*20+20);
            dec(Player.X);
            imgWorkField.Canvas.Draw((Player.X-1)*20+1,(Player.Y-1)*20+1,bmpSmile);
          end;
        end;

    end;

    if (Player.X=20) and (Player.Y=20) then  //���� ����� ����� �� �������� ������, ��
    begin
       bGameStat:=false;                 //��������� ����(���� ����� ���������� ������),
       MessageBox(0,'�� ������ ��������!','����������',0); //����������� ������
       butStopClick(Sender);                        //���������� ���� � ��������� ���������
       AddRecord(Edit1.Text,lblTime.Caption);        //��������� ������ � �������
    end;                                            
  end;
end;




//���� �� ������ Start
procedure TMainForm.butStartClick(Sender: TObject);
begin
  bGameStat:=True;            //��������, ��� ���� ��������
  butStop.Visible:=True;      //���������� ������ Stop
  butStart.Visible:=False;    //������ ������ Start
  MainForm.SetFocus;          //��� ��� ������ ������� ����� �����, �� � �������
                    // ������ ����� ���������� ������, ������ ����� ��� ������� �����
  DrawLabirint;               //������ ��������
  Player.X:=1;                //��� ������ ��������� ����������
  Player.Y:=1;


  imgWorkField.Canvas.Draw(1,1,bmpSmile);

  lbNames.Visible:=False;
  lbTimes.Visible:=False;
end;


//���� �� ������ Stop
procedure TMainForm.butStopClick(Sender: TObject);
begin
  bGameStat:=False;
  sGameTime:='00:00.0';       //���������� ������ � ��������
  butStart.Visible:=True;     //��������������� ������ Start
  butStop.Visible:=False;     //� ����� ������ Stop
  MainForm.SetFocus;          //���������� ����� ����� ������� �����

  lbNames.Visible:=True;      //���������� ������� � ���������
  lbTimes.Visible:=True;
                             //������� ����� � �������� ������
  imgWorkField.Canvas.Brush.Color:=CL_FINISH;
  imgWorkField.Canvas.Rectangle((20-1)*20+1,(20-1)*20+1,
                               (20-1)*20+20,(20-1)*20+20);
end;

procedure TMainForm.MainTimerTimer(Sender: TObject);
begin
  if bGameStat then          //���� ���� �� ��������, �� ������ ������ �� ������
  begin
    Inc(sGameTime[7]);          //����������� ������
    if sGameTime[7]>'9' then    //� ���� ������ ���� ������ '9',
    begin                     //�� ����������� ���������, � ��� �� ����� �������
      sGameTime[7]:='0';
      Inc(sGameTime[5]);
      if sGameTime[5]>'9' then
      begin
        sGameTime[5]:='0';
        Inc(sGameTime[4]);
        if sGameTime[4]>'5' then    //�� ��������, ��� � ������ ����� 60 ������,
        begin                        // ������ ������ �� ������ 5
          sGameTime[4]:='0';
          Inc(sGameTime[2]);
          if sGameTime[2]>'9' then
          begin
            sGameTime[2]:='0';
            Inc(sGameTime[1]);
            if sGameTime[1]>'9' then
              sGameTime[1]:='0'; //��������! ���� ���� ������ ������ 99 �����,
          end;                   //�� ��������� ������ ����� 0 :(
        end;
      end;
    end;
    lblTime.Caption:=sGameTime;  //��� �������� � �������� ��������� ������
  end;
end;


//��� ������� ��������� ��� ������� �����
procedure TMainForm.FormCreate(Sender: TObject);
var sRecord:string;
begin
  bmpSmile := TBitmap.Create;     //�������� ������ ��� ������ �������
  bmpSmile.LoadFromResourceName(HInstance,'SMILE');  //����������� ������� �� ��������

  AssignFile(fRec,'records.dat');
  if FileExists('records.dat') then    //��������� ���� � ���������, ���� �� ����
  begin
    Reset(fRec);
    while not Eof(fRec) do
    begin
      Readln(fRec,sRecord);            //� ��������� ������� ��������
      lbNames.Items.Add(sRecord);
      Readln(fRec,sRecord);
      lbTimes.Items.Add(sRecord);
    end;
    CloseFile(fRec);
  end;


end;


//��� ������� ��������� ��� ���������� �����
procedure TMainForm.FormDestroy(Sender: TObject);
var i:Integer;
begin
  bmpSmile.Free;        //����������� ������ ��� ������

  AssignFile(fRec,'records.dat');
  ReWrite(fRec);                    //�������������� ���� � ���������
  for i:=0 to lbNames.Items.Count-1 do
  begin
    Writeln(fRec,lbNames.Items[i]);
    Writeln(fRec,lbTimes.Items[i]);
  end;
  CloseFile(fRec);
end;

end.
