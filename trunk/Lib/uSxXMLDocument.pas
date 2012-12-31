unit uSxXMLDocument;

interface

uses
  XMLDoc, XMLIntf, Classes;

function FindOrAddChild(const XMLNode: IXMLNode; const NodeName: string): IXMLNode;
procedure AddXMLHeader(const XML: IXMLDocument; const FileDescription: string);

type
  TSxXMLDocument = class(TXMLDocument)
  protected
    procedure SetActive(const Value: Boolean); override;
  end;

implementation

uses
  uStrings,
  uProjectInfo;

function FindOrAddChild(const XMLNode: IXMLNode; const NodeName: string): IXMLNode;
begin
  Result := XMLNode.ChildNodes.FindNode(NodeName);
  if Result = nil then
    Result := XMLNode.AddChild(NodeName);
end;

function GetXMLComment(const FileDescription: string): string;
begin
  if FileDescription <> '' then
    Result := FileDescription + FileSep
  else
    Result := '';

  AppendStr(Result, GetProjectInfo(piProductName) + CharSpace + GetProjectInfo(piFileVersion) + FileSep);
  AppendStr(Result, GetProjectInfo(piLegalCopyright) + CharSpace + GetProjectInfo(piCompanyName) + FileSep);
  AppendStr(Result, GetProjectInfo(piWeb));
end;

procedure AddXMLHeader(const XML: IXMLDocument; const FileDescription: string);
begin
//  if XML.DocumentElement = nil then
  begin
    XML.ChildNodes.Add(XML.CreateNode(GetXMLComment(FileDescription), ntComment));
  end;
end;

{ TSxXMLDocument }

procedure TSxXMLDocument.SetActive(const Value: Boolean);
begin
  // Change default options
  Options := Options + [doNodeAutoIndent];

  inherited;
end;

end.
