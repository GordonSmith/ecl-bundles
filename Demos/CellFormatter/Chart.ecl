import $.GenData AS GenData;
import CellFormatter.CellFormatter;

states := dedup(sort(GenData.Dataset_Person, state), state);

Viz_Layout := record
  string2 state;
  integer NumRows;
  dataset(GenData.StateInitial_Layout) data__hidden;
  varstring bar__javascript;
  varstring pie__javascript;
  varstring bubble__javascript;
end;

d3Chart := CellFormatter.JavaScript.Chart('data__hidden', 'middleinitial', 'stat');
Viz_Layout TransStates(GenData.Layout_Person L) := TRANSFORM
	SELF.NumRows := 0;
	SELF.data__hidden := [];
    SELF.bar__javascript := d3Chart.Bar;
    SELF.pie__javascript := d3Chart.Pie;
    SELF.bubble__javascript := d3Chart.Bubble;
	SELF := L;
END;

vizStates := project(states, TransStates(LEFT));
output(vizStates, named('StatesMiddleInitial'));

Viz_Layout DeNormStates(Viz_Layout L, dataset(GenData.StateInitial_Layout) R) := TRANSFORM
	SELF.NumRows := count(R);
	SELF.data__hidden := R;
	SELF := L;
END;


ChartDataset := DENORMALIZE(vizStates, GenData.StateInitial_Rollup, LEFT.state = RIGHT.state, GROUP, DeNormStates(LEFT,ROWS(RIGHT)));
output(ChartDataset, named('Chart'));

