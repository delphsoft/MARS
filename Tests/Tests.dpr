(*
  Copyright 2016, MARS-Curiosity library

  Home: https://github.com/andrea-magni/MARS
*)
program Tests;

uses
  TestInsight.DUnit,
  ServerTests in 'ServerTests.pas',
  Tests.Authorization in 'Tests.Authorization.pas',
  Token.Resource.Standard in 'Resources\Token.Resource.Standard.pas',
  Authorization.Resource.Simple in 'Resources\Authorization.Resource.Simple.pas';

begin
  RunRegisteredTests;
end.
