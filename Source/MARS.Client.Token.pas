(*
  Copyright 2016, MARS-Curiosity library

  Home: https://github.com/andrea-magni/MARS
*)
unit MARS.Client.Token;

{$I MARS.inc}

interface

uses
  SysUtils, Classes
  , MARS.Core.JSON
  , MARS.Utils.Parameters
  , MARS.Utils.Parameters.JSON

  , MARS.Client.Resource
  ;

type
  {$ifdef DelphiXE2_UP}
    [ComponentPlatformsAttribute(
        pidWin32 or pidWin64
     or pidOSX32
     or pidiOSSimulator
     or pidiOSDevice
    {$ifdef DelphiXE7_UP}
     or pidiOSDevice32 or pidiOSDevice64
    {$endif}
     or pidAndroid)]
  {$endif}
  TMARSClientToken = class(TMARSClientResource)
  private
    FData: TJSONObject;
    FIsVerified: Boolean;
    FToken: string;
    FPassword: string;
    FUserName: string;
    FUserRoles: TStrings;
    FClaims: TMARSParameters;
    FExpiration: TDateTime;
    FIssuedAt: TDateTime;
    function GetIsExpired: Boolean;
  protected
    procedure AfterGET(); override;
    procedure BeforePOST(AContent: TMemoryStream); override;
    procedure AfterPOST(); override;
    procedure AfterDELETE; override;
    procedure ParseData; virtual;
    function GetAuthToken: string; override;
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Data: TJSONObject read FData;

    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
    property Token: string read FToken;
    property Authenticated: Boolean read FIsVerified;
    property IsVerified: Boolean read FIsVerified;
    property UserRoles: TStrings read FUserRoles;
    property IssuedAt: TDateTime read FIssuedAt;
    property Expiration: TDateTime read FExpiration;
    property Claims: TMARSParameters read FClaims;
    property IsExpired: Boolean read GetIsExpired;
  end;

procedure Register;

implementation

uses
    DateUtils
  , MARS.Core.Utils
  , MARS.Rtti.Utils;

procedure Register;
begin
  RegisterComponents('MARS-Curiosity Client', [TMARSClientToken]);
end;

{ TMARSClientToken }

procedure TMARSClientToken.AfterDELETE();
begin
  inherited;
  if Assigned(FData) then
    FData.Free;
  FData := StreamToJSONValue(Client.Response.ContentStream) as TJSONObject;
  ParseData;
end;

procedure TMARSClientToken.AfterGET();
begin
  inherited;
  if Assigned(FData) then
    FData.Free;
  FData := StreamToJSONValue(Client.Response.ContentStream) as TJSONObject;
  ParseData;
end;

procedure TMARSClientToken.AfterPOST();
begin
  inherited;

  if Assigned(FData) then
    FData.Free;
  FData := StreamToJSONValue(Client.Response.ContentStream) as TJSONObject;
  ParseData;
end;

procedure TMARSClientToken.AssignTo(Dest: TPersistent);
var
  LDest: TMARSClientToken;
begin
  inherited AssignTo(Dest);
  LDest := Dest as TMARSClientToken;

  LDest.UserName := UserName;
  LDest.Password := Password;
end;

procedure TMARSClientToken.BeforePOST(AContent: TMemoryStream);
var
  LStreamWriter: TStreamWriter;
begin
  inherited;
  LStreamWriter := TStreamWriter.Create(AContent);
  try
    LStreamWriter.Write('username=' + FUserName + '&password=' + FPassword);
  finally
    LStreamWriter.Free;
  end;
end;

constructor TMARSClientToken.Create(AOwner: TComponent);
begin
  inherited;
  Resource := 'token';
  FData := TJSONObject.Create;
  FUserRoles := TStringList.Create;
  FClaims := TMARSParameters.Create('');
end;

destructor TMARSClientToken.Destroy;
begin
  FClaims.Free;
  FUserRoles.Free;
  FData.Free;

  inherited;
end;

function TMARSClientToken.GetAuthToken: string;
begin
  Result := FToken;
end;

function TMARSClientToken.GetIsExpired: Boolean;
begin
  Result := Expiration < Now;
end;

procedure TMARSClientToken.ParseData;
var
  LClaims: TJSONObject;
begin
  FToken := FData.ReadStringValue('Token');
  FIsVerified := FData.ReadBoolValue('IsVerified');

  FClaims.Clear;
  if FData.TryGetValue('Claims', LClaims) then
  begin
    FClaims.LoadFromJSON(LClaims);

    FIssuedAt := UnixToDateTime(FClaims['iat'].AsInt64);
    FExpiration := UnixToDateTime(FClaims['exp'].AsInt64);
    FUserName := FClaims['UserName'].AsString;
    FUserRoles.CommaText := FClaims['Roles'].AsString;
  end;
end;

end.
