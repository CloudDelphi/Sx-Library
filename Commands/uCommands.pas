unit uCommands;

interface

uses
  Contnrs,
  uTypes,
  uRow,
  uCustomCommand;

type
  TCommands = class
  private
    FChanged: BG;
    FCommandIndexes: TArrayOfSG;
    FCommandNamesSorted: TArrayOfString;

    FCommands: TObjectList;

    function PreviewTableCommand(const ACommand: TCustomCommand): TRow;
    procedure SortCommands;
  public
    constructor Create;
    destructor Destroy; override;

    function FindByString(const ACommandShortcut: string): TCustomCommand;
    function FindByStringException(const ACommandShortcut: string): TCustomCommand;

    procedure PreviewToConsole;
    function PreviewAsString: string;

    procedure Add(const ACustomCommand: TCustomCommand); overload;
    procedure Add(const ACommands: TObjectList); overload;
    procedure Delete(const ACustomCommand: TCustomCommand);

    property List: TObjectList read FCommands;
  end;

implementation

uses
  Windows,
  SysUtils,
  Classes,

  uTextAlignment,
  uTable,
  uMath,
  uStrings,
  uSorts,
  uFind,
  uEParseError;

{ TCommands }

procedure TCommands.Add(const ACustomCommand: TCustomCommand);
begin
  FCommands.Add(ACustomCommand);
  FChanged := True;
end;

procedure TCommands.Add(const ACommands: TObjectList);
var
  i: SG;
begin
  for i := 0 to ACommands.Count - 1 do
  begin
    FCommands.Add(TCustomCommand(ACommands[i]));
    FChanged := True;
  end;
end;

constructor TCommands.Create;
begin
  inherited;

  FCommands := TObjectList.Create;
  FCommands.OwnsObjects := True;
end;

destructor TCommands.Destroy;
begin
  FCommands.Free;

  inherited;
end;

function TCommands.FindByString(
  const ACommandShortcut: string): TCustomCommand;
var
  FromV, ToV: SG;
begin
  if FChanged then
    SortCommands;

	if not FindS(FCommandNamesSorted, ACommandShortcut, FromV, ToV) then
		Result := nil
  else
    Result := TCustomCommand(FCommands[FCommandIndexes[FromV]]);
end;

function TCommands.FindByStringException(const ACommandShortcut: string): TCustomCommand;
begin
  Result := FindByString(ACommandShortcut);
  if Result = nil then
		raise EParseError.Create(['Valid command'], ACommandShortcut);
  if not Result.Enabled then
		raise EParseError.Create(['Enabled command'], ACommandShortcut);
end;

function TCommands.PreviewAsString: string;
var
  i: SG;
begin
  Result := '';
  for i := 0 to FCommands.Count - 1 do
  begin
    if TCustomCommand(FCommands[i]).Enabled then
      Result := Result + TCustomCommand(FCommands[i]).GetShortcutAndSyntax + ' ' + TCustomCommand(FCommands[i]).Description + LineSep;
  end;
end;

procedure TCommands.PreviewToConsole;
var
  Table: TTable;
  Row: TRow;
  i: SG;
begin
  Table := TTable.Create(1 + FCommands.Count);
  try
    Row := TRow.Create(2);
    Row.Columns[0].Text := 'Command name and parameters';
    Row.Columns[0].HorizontalAlignment := haCenter;
    Row.Columns[1].Text := 'Description';
    Row.Columns[1].VerticalAlignment := vaCenter;
    Table.Data[0] := Row;

    for i := 0 to FCommands.Count - 1 do
    begin
      Row := PreviewTableCommand(TCustomCommand(FCommands[i]));
      Table.Data[i + 1] := Row;
    end;
    Table.WriteToConsole;
  finally
    Table.Free;
  end;
end;

procedure TCommands.SortCommands;
var
	i: SG;
  FCommandNamesSorted2: TArrayOfString;
begin
  FChanged := False;
  SetLength(FCommandNamesSorted, 0);
  SetLength(FCommandNamesSorted2, 0);
  SetLength(FCommandIndexes, FCommands.Count);
  SetLength(FCommandNamesSorted2, FCommands.Count);
	FillOrderUG(FCommandIndexes[0], Length(FCommandIndexes));

	for i := 0 to FCommands.Count - 1 do
	begin
		FCommandNamesSorted2[i] := LowerCase(DelCharsF(TCustomCommand(FCommands[i]).Shortcut, CharSpace));
	end;
	SortStrBinary(PArraySG(@FCommandIndexes[0]), PArrayString(@FCommandNamesSorted2[0]), Length(FCommandIndexes));

  SetLength(FCommandNamesSorted, Length(FCommandIndexes));
	for i := 0 to Length(FCommandIndexes) - 1 do
	begin
		FCommandNamesSorted[i] := FCommandNamesSorted2[FCommandIndexes[i]];
	end;
end;

procedure TCommands.Delete(const ACustomCommand: TCustomCommand);
var
  Index: SG;
begin
  Index := FCommands.IndexOf(ACustomCommand);
  if Index >= 0 then
    ACustomCommand.Enabled := False
  else
    raise EArgumentException.Create('Can not delete command "' + ACustomCommand.Shortcut + '" because not found in command list.');
end;

function TCommands.PreviewTableCommand(const ACommand: TCustomCommand): TRow;
var
  Row: TRow;
begin
  Row := TRow.Create(2);
  Row.Columns[0].Text := ACommand.GetShortcutAndSyntax;
  Row.Columns[1].Text := ACommand.Description;
  Result := Row;
end;

end.
