//* File:     Lib\uStyle.pas
//* Created:  2000-08-01
//* Modified: 2005-03-13
//* Version:  X.X.34.X
//* Author:   Safranek David (Safrad)
//* E-Mail:   safrad@centrum.cz
//* Web:      http://safrad.webzdarma.cz

unit uStyle;

interface

uses
	uTypes, uDForm, uDBitmap, uDIni,
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, uDButton, ExtCtrls;

type
	TOnApplyStyle = procedure(Style: TDrawStyle);

	TfStyle = class(TDForm)
		ComboBoxStyles: TComboBox;
		ButtonOk: TDButton;
		ButtonCancel: TDButton;
		ButtonApply: TDButton;
    ButtonColor0: TDButton;
    ButtonSelectFile: TDButton;
    ButtonColor1: TDButton;
    ComboBoxEffect: TComboBox;
    ComboBoxLineSize: TComboBox;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
		procedure FormCreate(Sender: TObject);
		procedure FormToData(Sender: TObject);
		procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ButtonColor0Click(Sender: TObject);
	private
		{ Private declarations }
		TCurVal, TDefVal, NowVal: TDrawStyle;
		OnApply: TOnApplyStyle;
		procedure DataToForm(Sender: TObject);
	public
		{ Public declarations }
	end;

procedure RWDrawStyle(MainIni: TDIniFile; Name: string; var DS: TDrawStyle; Save: BG);

var
	fStyle: TfStyle;

function GetStyle(Prompt: string;
	var CurVal: TDrawStyle; const DefVal: TDrawStyle; OnApplyStyle: TOnApplyStyle): Boolean;


implementation

{$R *.dfm}
uses uGColor, uStrings, uFormat;

procedure TfStyle.FormCreate(Sender: TObject);
var i: SG;
begin
	Background := baUser;
	for i := 0 to Length(GraphicStyleNames) - 1 do
		ComboBoxStyles.Items.Add(GraphicStyleNames[TGraphicStyle(i)]);

	for i := 0 to Length(EffectNames) - 1 do
		ComboBoxEffect.Items.Add(EffectNames[TEffect(i)]);

	for i := 1 to 16 do
		ComboBoxLineSize.Items.Add(NToS(i));
end;

procedure RWDrawStyle(MainIni: TDIniFile; Name: string; var DS: TDrawStyle; Save: BG);
begin
	MainIni.RWNum(Name, 'Style', U1(DS.Style), Save);
	MainIni.RWNum(Name, 'Effect', U1(DS.Effect), Save);
	MainIni.RWNum(Name, 'Color0', S4(DS.Colors[0]), Save);
	MainIni.RWNum(Name, 'Color1', S4(DS.Colors[1]), Save);
	MainIni.RWNum(Name, 'BorderSize', DS.BorderSize, Save);
end;

procedure TfStyle.FormToData(Sender: TObject);
begin
	NowVal.Style := TGraphicStyle(ComboBoxStyles.ItemIndex);
	NowVal.Effect := TEffect(ComboBoxEffect.ItemIndex);
	NowVal.BorderSize := ComboBoxLineSize.ItemIndex + 1;

	Fill;
end;

procedure TfStyle.DataToForm(Sender: TObject);
begin
	ComboBoxStyles.ItemIndex := SG(NowVal.Style);
	ComboBoxEffect.ItemIndex := SG(NowVal.Effect);
	ComboBoxLineSize.ItemIndex := NowVal.BorderSize - 1;
end;

function GetStyle(Prompt: string;
	var CurVal: TDrawStyle; const DefVal: TDrawStyle; OnApplyStyle: TOnApplyStyle): Boolean;
begin
	if not Assigned(fStyle) then
	begin
		fStyle := TfStyle.Create(Application.MainForm);
	end;
	fStyle.ButtonApply.Enabled := Assigned(OnApplyStyle);
	fStyle.OnApply := OnApplyStyle;
	fStyle.TCurVal := CurVal;
	fStyle.TDefVal := DefVal;
	fStyle.NowVal := fStyle.TCurVal;
	fStyle.Caption := DelCharsF(Prompt, '&');

	fStyle.DataToForm(nil);
	fStyle.Fill;

{	fGetInt.TrackBar.OnChange := nil;
	fGetInt.TrackBar.Frequency := (fGetInt.TMaxVal - fGetInt.TMinVal + 19) div 20;
	fGetInt.TrackBar.PageSize := (fGetInt.TMaxVal - fGetInt.TMinVal + 19) div 20;
	if fGetInt.TMaxVal < fGetInt.TrackBar.Min then
	begin
		fGetInt.TrackBar.Min := fGetInt.TMinVal;
		fGetInt.TrackBar.Max := fGetInt.TMaxVal;
	end
	else
	begin
		fGetInt.TrackBar.Max := fGetInt.TMaxVal;
		fGetInt.TrackBar.Min := fGetInt.TMinVal;
	end;
	fGetInt.TrackBar.SelStart := fGetInt.TCurVal;
	fGetInt.TrackBar.SelEnd := fGetInt.TCurVal;
	fGetInt.TrackBar.OnChange := fGetInt.TrackBarChange;}

{ if MaxVal-MinVal > 112 then
		TrackBar.TickStyle := tsNone
	else
		TrackBar.TickStyle := tsAuto;}
{	fStyle.InitTrackBar;
	fGetInt.InitButtons;
	fGetInt.InitEdit;
	if fGetInt.ActiveControl <> fGetInt.EditInput then fGetInt.ActiveControl := fGetInt.EditInput;}
	if Assigned(fStyle.OnApply) then
	begin
		fStyle.FormStyle := fsStayOnTop;
		fStyle.Show;
		Result := True;
	end
	else
	begin
		fStyle.FormStyle := fsNormal;
		if fStyle.ShowModal = mrOK then
		begin
			CurVal := fStyle.NowVal;
			Result := True;
		end
		else
		begin
			Result := False;
		end;
	end;
end;

procedure TfStyle.FormResize(Sender: TObject);
begin
	Fill;
end;

procedure TfStyle.FormPaint(Sender: TObject);
begin
	BackBitmap.DrawStyle(NowVal, 0, 0, BackBitmap.Width - 1, BackBitmap.Height - 1);
	Invalidate;
end;

procedure TfStyle.ButtonColor0Click(Sender: TObject);
begin
	if GetColor('Color', NowVal.Colors[TComponent(Sender).Tag], clSilver, nil) then
		FormToData(Sender);
end;

end.
