unit LabUnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ValEdit;

const T = True;     //для удобства заполенения массива даём короткие имена
      F = False;
      CL_FINISH = $aaaaff;  //цвет финишной клетки
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
  bGameStat: Boolean;                        //запущена ли игра
  sGameTime: string[7] = '00:00.0';        //в этой строке хранится время
  Player:TPoint;                      //это положение игрока
  bmpSmile: TBitmap;                   //тут хранится картинка смайла
  fRec:Text;                           //файловаая переменная

{если есть лабиринт 2х2 клетки, то будет на каждую строку по 3 вертикальных стенки
и на каждый столбец по 3 горизонтальных.}
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

procedure TMainForm.DrawLabirint();     //по массивам MapVert и MapHoriz
var i,j:Integer;                         //рисует лабиринт
begin
  imgWorkField.Canvas.Pen.Color:=clBlack;
  for j:=0 to 20 do                         //сначала рисуем вертикальные стенки
    for i:=1 to 20 do
      if MapVert[i,j] then
      begin
        imgWorkField.Canvas.MoveTo(j*20,i*20-20);
        imgWorkField.Canvas.LineTo(j*20,i*20+1);
      end;

  for i:=0 to 20 do                           //затнм вертикальные
    for j:=1 to 20 do
      if MapHoriz[i,j] then
      begin
        imgWorkField.Canvas.MoveTo(j*20-20,i*20);
        imgWorkField.Canvas.LineTo(j*20+1,i*20);
      end;

  imgWorkField.Canvas.Brush.Color:=CL_FINISH;    //устанавливаем цвет для финишной клетки
  imgWorkField.Canvas.Pen.Color:=CL_FINISH;     //и кисти, и пера затем, что бы не было видно рамки квадрата
  imgWorkField.Canvas.Rectangle((20-1)*20+1,(20-1)*20+1,
                               (20-1)*20+20,(20-1)*20+20);//на финишной клетке рисуем квадрат
end;

procedure TMainForm.AddRecord(sName,sTime:string);
var i:Integer;
begin
  i:=0;
  while (i<lbNames.Items.Count) and       //ущем первую строку со временем, которая
        (sTime > lbTimes.Items[i]) do     //больше текущего времени
     inc(i);

  lbTimes.Items.Insert(i,sTime);       //и вставляем только полученный результат
  lbNames.Items.Insert(i,sName);
  lbTimes.Selected[i]:=True;          //выделяем новый рекорд
  lbNames.Selected[i]:=True;
end;



//эта функция вызывается при нажатии по клавише в главной форме
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if bGameStat then
  begin
    imgWorkField.Canvas.Pen.Color:=clWhite;    //так как надо затирать старый смайл
    imgWorkField.Canvas.Brush.Color:=clWhite;  //то устанавливаем белый цвет
    case Key of                             //в зависимости от нажатой кнопки меняем кооржинату
    VK_DOWN:                                //в Player, рисуем былй квадрат в старой клетки и рисуем смайл в новой
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

    if (Player.X=20) and (Player.Y=20) then  //если смайл встал на финишную клетку, то
    begin
       bGameStat:=false;                 //завершаем игру(чтоб сразу заморозить таймер),
       MessageBox(0,'Вы прошли лабиринт!','Поздравляю',0); //поздравляем игрока
       butStopClick(Sender);                        //сбрасываем игру в начальное состояние
       AddRecord(Edit1.Text,lblTime.Caption);        //добавляем запись в рекорды
    end;                                            
  end;
end;




//клик по кнопке Start
procedure TMainForm.butStartClick(Sender: TObject);
begin
  bGameStat:=True;            //Отмечаем, что игра началась
  butStop.Visible:=True;      //Показываем кнопку Stop
  butStart.Visible:=False;    //прячем кнопку Start
  MainForm.SetFocus;          //Так как кнопка забрала фокус ввода, то и нажатия
                    // клавиш будут отсылаться кнопке, потому вернём его главной форме
  DrawLabirint;               //рисуем лабиринт
  Player.X:=1;                //даём игроку начальные координаты
  Player.Y:=1;


  imgWorkField.Canvas.Draw(1,1,bmpSmile);

  lbNames.Visible:=False;
  lbTimes.Visible:=False;
end;


//клик по кнопке Stop
procedure TMainForm.butStopClick(Sender: TObject);
begin
  bGameStat:=False;
  sGameTime:='00:00.0';       //сбрасываем строку с временем
  butStart.Visible:=True;     //восстанавливаем кнопку Start
  butStop.Visible:=False;     //и назад прячем Stop
  MainForm.SetFocus;          //возвращаем фокус ввода главной форме

  lbNames.Visible:=True;      //показываем таблицу с рекордами
  lbTimes.Visible:=True;
                             //стираем смайл с финишной клетки
  imgWorkField.Canvas.Brush.Color:=CL_FINISH;
  imgWorkField.Canvas.Rectangle((20-1)*20+1,(20-1)*20+1,
                               (20-1)*20+20,(20-1)*20+20);
end;

procedure TMainForm.MainTimerTimer(Sender: TObject);
begin
  if bGameStat then          //если игра не запущена, то таймер ничего не меняет
  begin
    Inc(sGameTime[7]);          //увеличиваем символ
    if sGameTime[7]>'9' then    //и если символ стал больше '9',
    begin                     //то увеличиваем следующий, и так со всеми цифрами
      sGameTime[7]:='0';
      Inc(sGameTime[5]);
      if sGameTime[5]>'9' then
      begin
        sGameTime[5]:='0';
        Inc(sGameTime[4]);
        if sGameTime[4]>'5' then    //не забываем, что в минуте всего 60 секунд,
        begin                        // потому символ не больше 5
          sGameTime[4]:='0';
          Inc(sGameTime[2]);
          if sGameTime[2]>'9' then
          begin
            sGameTime[2]:='0';
            Inc(sGameTime[1]);
            if sGameTime[1]>'9' then
              sGameTime[1]:='0'; //ВНИМАНИЕ! Если юзер играет больше 99 минут,
          end;                   //то следующая минута будет 0 :(
        end;
      end;
    end;
    lblTime.Caption:=sGameTime;  //даём элементу с временем изменённую строку
  end;
end;


//эта функция вызывется при запуске проги
procedure TMainForm.FormCreate(Sender: TObject);
var sRecord:string;
begin
  bmpSmile := TBitmap.Create;     //выделяем память для класса битмапа
  bmpSmile.LoadFromResourceName(HInstance,'SMILE');  //вытаскиваем рисунок из ресурсов

  AssignFile(fRec,'records.dat');
  if FileExists('records.dat') then    //открываем файл с рекордами, если он есть
  begin
    Reset(fRec);
    while not Eof(fRec) do
    begin
      Readln(fRec,sRecord);            //и заполняем таблицу рекордов
      lbNames.Items.Add(sRecord);
      Readln(fRec,sRecord);
      lbTimes.Items.Add(sRecord);
    end;
    CloseFile(fRec);
  end;


end;


//Эта функция вызовется при завершении проги
procedure TMainForm.FormDestroy(Sender: TObject);
var i:Integer;
begin
  bmpSmile.Free;        //освобождаем память для смайла

  AssignFile(fRec,'records.dat');
  ReWrite(fRec);                    //перезаписываем файл с рекордами
  for i:=0 to lbNames.Items.Count-1 do
  begin
    Writeln(fRec,lbNames.Items[i]);
    Writeln(fRec,lbTimes.Items[i]);
  end;
  CloseFile(fRec);
end;

end.
