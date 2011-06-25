unit uDViewLogger;

interface

uses uTypes, uLogger, uData, uDView;

type
	TDViewLogger = class(TLogger)
	private
		Messages: TData;
		FDViewLog: TDView;
	public
		constructor Create(DViewLog: TDView);
		procedure Add(const Line: string; const LogType: TMessageLevel); override;
		function Get(const Index: SG): PLogMessage;
	end;

implementation

uses SysUtils, uLog;

procedure TDViewLogger.Add(const Line: string;
	const LogType: TMessageLevel);
var
	M: PLogMessage;
begin
	inherited;

	M := Messages.Add;
	M.DateTime := Now;
	M.Level := LogType;
	M.Text := Line;
	FDViewLog.RowCount := Messages.Count;
	FDViewLog.DataChanged;
	MainLogAdd(Line, LogType);
end;

function TDViewLogger.Get(const Index: SG): PLogMessage;
begin
	Result := Messages.Get(Index);
end;

constructor TDViewLogger.Create(DViewLog: TDView);
begin
	FDViewLog := DViewLog;
	Messages := TData.Create;
	Messages.ItemSize := SizeOf(TLogMessage);
end;

end.
