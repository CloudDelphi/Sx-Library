unit uDefaultCommands;

interface

uses
  uCommands;

type
  TDefaultCommands = class(TCommands)
  public
    constructor Create;

  end;

implementation

uses
  uLog,
  uDIniFile,
  uExitCommand,
  uRestartCommand,
  uHelpCommand,
  uAboutCommand,
  uStateCommand,
  uSystemInfoCommand,
  uShowFileCommand;

{ TDefaultCommands }

constructor TDefaultCommands.Create;
var
  FHelpCommand: THelpCommand;
  FExitCommand: TExitCommand;
  FQuitCommand: TQuitCommand;
  FRestartCommand: TRestartCommand;
  FAboutCommand: TAboutCommand;
  FStateCommand: TStateCommand;
  FSystemInfoCommand: TSystemInfoCommand;
  FShowLogCommand,
  FShowIniCommand,
  FShowLocalIniCommand: TShowFileCommand;
begin
  inherited;

  FHelpCommand := THelpCommand.Create;
  FHelpCommand.Commands := Self;
  Add(FHelpCommand);

  FExitCommand := TExitCommand.Create;
  Add(FExitCommand);

  FQuitCommand := TQuitCommand.Create;
  Add(FQuitCommand);

  FRestartCommand := TRestartCommand.Create;
  Add(FRestartCommand);

  FAboutCommand := TAboutCommand.Create;
  Add(FAboutCommand);

  FStateCommand := TStateCommand.Create;
  Add(FStateCommand);

  FSystemInfoCommand := TSystemInfoCommand.Create;
  Add(FSystemInfoCommand);

  FShowLogCommand := TShowFileCommand.Create;
  FShowLogCommand.Shortcut := 'ShowLog';
  FShowLogCommand.Description := 'Show log file.';
  FShowLogCommand.FileName := MainLog.FileName;
  Add(FShowLogCommand);

  FShowIniCommand := TShowFileCommand.Create;
  FShowIniCommand.Shortcut := 'ShowIni';
  FShowIniCommand.Description := 'Show main configuration file.';
  FShowIniCommand.FileName := MainIni.FileName;
  Add(FShowIniCommand);

  FShowLocalIniCommand := TShowFileCommand.Create;
  FShowLocalIniCommand.Shortcut := 'ShowLocalIni';
  FShowLocalIniCommand.Description := 'Show local configuration file.';
  FShowLocalIniCommand.FileName := LocalMainIni.FileName;
  Add(FShowLocalIniCommand);
end;

end.
