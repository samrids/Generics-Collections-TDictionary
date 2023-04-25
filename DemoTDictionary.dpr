program DemoTDictionary;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Math,
  System.Types;

///EqualsValue

type
  TCity = class
    Country: String;
    Latitude: Double;
    Longitude: Double;
  end;

const
  EPSILON = 0.0000001;

var
  Dictionary: TDictionary<String, TCity>;
  City, Value: TCity;
  Key: String;

begin
  { Create the dictionary. }
  Dictionary := TDictionary<String, TCity>.Create;
  City := TCity.Create;
  { Add some key-value pairs to the dictionary. }
  City.Country := 'Romania';
  City.Latitude := 47.16;
  City.Longitude := 27.58;
  Dictionary.Add('Iasi', City);

  City := TCity.Create;
  City.Country := 'United Kingdom';
  City.Latitude := 51.5;
  City.Longitude := -0.17;
  Dictionary.Add('London', City);

  City := TCity.Create;
  City.Country := 'Argentina';
  { Notice the wrong coordinates }
  City.Latitude := 0;
  City.Longitude := 0;
  Dictionary.Add('Buenos Aires', City);

  { Display the current number of key-value entries. }
  writeln('Number of pairs in the dictionary: ' +
  IntToStr(Dictionary.Count));

  // Try looking up "Iasi".
  if (Dictionary.TryGetValue('Iasi', City) = True) then
  begin
    writeln(
    'Iasi is located in ' + City.Country +
    ' with latitude = ' + FloatToStrF(City.Latitude, ffFixed, 4, 2) +
    ' and longitude = ' + FloatToStrF(City.Longitude, ffFixed, 4, 2)
    );
  end
  else
    writeln('Could not find Iasi in the dictionary');

  { Remove the "Iasi" key from dictionary. }
  Dictionary.Remove('Iasi');

  { Make sure the dictionary's capacity is set to the number of entries. }
  Dictionary.TrimExcess;

  { Test if "Iasi" is a key in the dictionary. }
  if Dictionary.ContainsKey('Iasi') then
    writeln('The key "Iasi" is in the dictionary.')
  else
    writeln('The key "Iasi" is not in the dictionary.');

  { Test how (United Kingdom, 51.5, -0.17) is a value in the dictionary but
    ContainsValue returns False if passed a different instance of TCity with the
    same data, as different instances have different references. }
  if Dictionary.ContainsKey('London') then
  begin
    Dictionary.TryGetValue('London', City);
    if (City.Country = 'United Kingdom') and (CompareValue(City.Latitude, 51.5, EPSILON) = EqualsValue) and (CompareValue(City.Longitude, -0.17, EPSILON) = EqualsValue) then
      writeln('The value (United Kingdom, 51.5, -0.17) is in the dictionary.')
    else
      writeln('Error: The value (United Kingdom, 51.5, -0.17) is not in the dictionary.');
    City := TCity.Create;
    City.Country := 'United Kingdom';
    City.Latitude := 51.5;
    City.Longitude := -0.17;
    if Dictionary.ContainsValue(City) then
      writeln('Error: A new instance of TCity with values (United Kingdom, 51.5, -0.17) matches an existing instance in the dictionary.')
    else
      writeln('A new instance of TCity with values (United Kingdom, 51.5, -0.17) does not match any existing instance in the dictionary.');
    City.Free;
  end
  else
    writeln('Error: The key "London" is not in the dictionary.');

  { Update the coordinates to the correct ones. }
  City := TCity.Create;
  City.Country := 'Argentina';
  City.Latitude := -34.6;
  City.Longitude := -58.45;
  Dictionary.AddOrSetValue('Buenos Aires', City);

  { Generate the exception "Duplicates not allowed". }
  try
    Dictionary.Add('Buenos Aires', City);
  except
    on Exception do
      writeln('Could not add entry. Duplicates are not allowed.');
  end;

  { Display all countries. }
  writeln('All countries:');
  for Value in Dictionary.Values do
    writeln(Value.Country);

  { Iterate through all keys in the dictionary and display their coordinates. }
  writeln('All cities and their coordinates:');
  for Key in Dictionary.Keys do
  begin
    writeln(Key + ': ' + FloatToStrF(Dictionary.Items[Key].Latitude, ffFixed, 4, 2) + ', ' +
    FloatToStrF(Dictionary.Items[Key].Longitude, ffFixed, 4, 2));
  end;

  { Clear all entries in the dictionary. }
  Dictionary.Clear;

  { There should be no entries at this point. }
  writeln('Number of key-value pairs in the dictionary after cleaning: ' + IntToStr(Dictionary.Count));

  { Free the memory allocated for the dictionary. }
  Dictionary.Free;
  City.Free;
  readln;
end.
