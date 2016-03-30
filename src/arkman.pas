unit arkman;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SDL2, SDL2_image, arktypes;

type
  PTextureList = ^TTextureList;

  TTextureList = record
	Name: string;
	id, refcount: integer;
	tx: PSDL_Texture;
  end;

  PArkanoid = ^TArkanoid;

  { TTextureManager }

  TTextureManager = class(TObject)
	class var TextureList: array of PTextureList;
	class var texcount: integer;
  protected
	ArkGame: PArkanoid;
	function IsLoaded(Name: string): integer;
	procedure IncRef(tl: PTextureList);
	procedure DecRef(tl: PTextureList);
	procedure DeleteTexture(tl: PTextureList);
  public
	constructor Create(Ark: PArkanoid);
	destructor Destroy; reintroduce;
	function LoadTexture(Name: string): integer;
	function GetTexture(Name: string): PSDL_Texture;
	function GetTexture(id: integer): PSDL_Texture;
        procedure ReleaseTexture(Name: string);
        procedure ReleaseTexture(id: integer);
  end;

    { TSoundManager }

    TSoundManager = class(TObject)
    private

    protected

    public

        constructor Create; reintroduce;
        destructor Destroy; reintroduce;
    published
    end;


implementation

{ TSoundManager }

constructor TSoundManager.Create;
begin

end;

destructor TSoundManager.Destroy;
begin

end;

{ TTextureManager }

function TTextureManager.IsLoaded(Name: string): integer;
var
  node: PTextureList;
  found: integer;
begin
  found := -1;
  for node in TextureList do
  begin
	if CompareStr(Name, node^.Name) = 0 then
	begin
	  found := node^.id;
	  writeln(Name, ' found. Already loaded!');
	  break;
	end;
  end;
  Result := found;
end;

procedure TTextureManager.IncRef(tl: PTextureList);
begin
  Inc(tl^.refcount);
end;

procedure TTextureManager.DecRef(tl: PTextureList);
begin
  Dec(tl^.refcount);
  if tl^.refcount <= 0 then
  begin
	DeleteTexture(tl);
  end;
end;

{
    TTextureManager.DeleteTexture
    It doesn't destroy the record, just the SDL_Texture
}
procedure TTextureManager.DeleteTexture(tl: PTextureList);
begin
  writeln(tl^.Name, ' deleted');
  SDL_DestroyTexture(tl^.tx);
  tl^.tx:=nil;
  tl^.Name:='nil';
  tl^.refcount:=-1;
end;

constructor TTextureManager.Create(Ark: PArkanoid);
begin
  ArkGame := Ark;
  texcount := 0;
end;

destructor TTextureManager.Destroy;
var
  node: PTextureList;
begin
  for node in TextureList do
  begin
        DeleteTexture(node);
        dispose(node);
  end;
  SetLength(TextureList,0);
end;

function TTextureManager.LoadTexture(Name: string): integer;
var
  id: integer;
  node: PTextureList;
begin
  id := IsLoaded(Name);
  if id > -1 then
  begin
	Result := id;
  end
  else
  begin
	node := new(PTextureList);
	node^.id := texcount;
	node^.Name := Name;
	node^.refcount := 1;
	node^.tx := IMG_LoadTexture(ArkGame^.PRenderer, PChar(Name));
	if node^.tx = nil then
	begin
	  writeln('Error: ', IMG_GetError());
	end
	else
	begin
	  writeln(Name, ' loaded succesfully! id: ', node^.id);
          result:=node^.id;
	end;
        SetLength(TextureList, texcount+1);
	TextureList[texcount]:=node;
        Inc(texcount);
  end;
end;

function TTextureManager.GetTexture(Name: string): PSDL_Texture;
var
  id: integer;
begin
  id := IsLoaded(Name);
  if (id > -1) and (id<texcount) then
  begin
    Result:=TextureList[id]^.tx;
    IncRef(TextureList[id]);
  end
  else
  begin
       Result:=nil;
       writeln(Name, ' not loaded! Load it!');
  end;
end;

function TTextureManager.GetTexture(id: integer): PSDL_Texture;
begin
  Result := nil;
  if id < texcount then
  begin
    Result:=TextureList[id]^.tx;
    IncRef(TextureList[id]);
  end else
  begin
       writeln('Texture id: ', id, ' not found!');
  end;
end;

procedure TTextureManager.ReleaseTexture(Name: string);
var id: integer;
begin
  id:=IsLoaded(Name);
  if id>-1 then
  begin
    DecRef(TextureList[id]);
  end;
end;

procedure TTextureManager.ReleaseTexture(id: integer);
begin
  if id<texcount then
  begin
    DecRef(TextureList[id]);
  end;
end;

end.
