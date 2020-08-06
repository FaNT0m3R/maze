object MainForm: TMainForm
  Left = 807
  Top = 209
  Width = 451
  Height = 493
  Caption = #1051#1072#1073#1080#1088#1080#1085#1090
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object lblTime: TLabel
    Left = 360
    Top = 8
    Width = 45
    Height = 24
    Caption = '00:00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object imgWorkField: TImage
    Left = 16
    Top = 48
    Width = 401
    Height = 401
  end
  object Label1: TLabel
    Left = 96
    Top = 15
    Width = 57
    Height = 24
    Align = alCustom
    Caption = #1042#1072#1096#1077' '#1080#1084#1103':'
  end
  object butStart: TButton
    Left = 24
    Top = 8
    Width = 65
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    TabStop = False
    OnClick = butStartClick
  end
  object butStop: TButton
    Left = 24
    Top = 8
    Width = 65
    Height = 25
    Caption = 'Stop'
    TabOrder = 1
    TabStop = False
    Visible = False
    OnClick = butStopClick
  end
  object lbNames: TListBox
    Left = 16
    Top = 48
    Width = 329
    Height = 401
    ItemHeight = 13
    TabOrder = 2
  end
  object lbTimes: TListBox
    Left = 344
    Top = 48
    Width = 73
    Height = 401
    ItemHeight = 13
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 152
    Top = 12
    Width = 193
    Height = 22
    TabOrder = 4
    Text = #1048#1075#1088#1086#1082
  end
  object MainTimer: TTimer
    Interval = 100
    OnTimer = MainTimerTimer
    Left = 424
    Top = 16
  end
end
