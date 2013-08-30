import $.GenData;
import CellFormatter.CellFormatter;

CityRecord := record
  string2 state;
  qstring5 zip;
  string1 label;
  integer stat;
end;

CityRecord toCity(GenData.StateZipCityInitial_Layout L) := transform
  self.label := L.middleinitial;
  self.stat := L.stat;
  SELF := L;
end;

cities := project(GenData.StateZipCityInitial_Rollup, toCity(LEFT));

ZipRecord := record
  string2 state;
  qstring5 label;
  dataset(CityRecord) kids;
end;

ZipRecord DeNormCities(GenData.Layout_Person L, dataset(CityRecord) R2) := transform
    self.state := L.state;
    self.label := L.zip;
    self.kids := choosen(R2, 6);
    self := L;
end;

zips := dedup(sort(GenData.Dataset_Person, state, zip), state, zip);
zipCities := DENORMALIZE(zips, cities, LEFT.zip = RIGHT.zip, GROUP, DeNormCities(LEFT,ROWS(RIGHT)));
//zipCities;

StateRecord := record
  string2 label;
  dataset(ZipRecord) kids;
end;

StateRecord DeNormZips(GenData.Layout_Person L, dataset(ZipRecord) R3) := TRANSFORM
  self.label := L.state;
  self.kids := choosen(R3, 5);
  self := L;
end;

states := dedup(sort(GenData.Dataset_Person, state), state);
stateZips := DENORMALIZE(states, zipCities, LEFT.state = RIGHT.state, GROUP, DeNormZips(LEFT,ROWS(RIGHT)));
//stateZips;

CountryRecord := record
  string22 label;
  dataset(StateRecord) kids;
end;

Viz_Layout := record
  CountryRecord data__hidden;
  varstring ClusterDendrogram__javascript;
  varstring CirclePacking__javascript;
  varstring ReingoldTilfordTree__javascript;
  varstring SunburstPartition__javascript;
end;

d3Tree := CellFormatter.JavaScript.Tree('data__hidden', 'label', 'kids', 'stat');
output(choosen(stateZips, 4), named('StateTree'));
output(dataset([{{'USA', choosen(stateZips, 4)}, d3Tree.ClusterDendrogram, d3Tree.CirclePacking, d3Tree.ReingoldTilfordTree, d3Tree.SunburstPartition}], Viz_Layout), named('Tree'));
