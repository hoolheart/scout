
from qiskit_metal.qlibrary.tlines.meandered import RouteMeander

from qiskit_metal.qlibrary.qubits.transmon_pocket import TransmonPocket

from qiskit_metal import designs, MetalGUI

design = designs.DesignPlanar()

gui = MetalGUI(design)



            # WARNING
#options_connection_pads failed to have a value
Q1 = TransmonPocket(
design,
name='Q1',
options={'connection_pads': {'bus1': {'cpw_extend': '100um',
                              'cpw_gap': 'cpw_gap',
                              'cpw_width': 'cpw_width',
                              'loc_H': 1,
                              'loc_W': -1,
                              'pad_cpw_extent': '25um',
                              'pad_cpw_shift': '5um',
                              'pad_gap': '15um',
                              'pad_height': '30um',
                              'pad_width': '125um',
                              'pocket_extent': '5um',
                              'pocket_rise': '65um'},
                     'bus2': {'cpw_extend': '100um',
                              'cpw_gap': 'cpw_gap',
                              'cpw_width': 'cpw_width',
                              'loc_H': -1,
                              'loc_W': -1,
                              'pad_cpw_extent': '25um',
                              'pad_cpw_shift': '5um',
                              'pad_gap': '15um',
                              'pad_height': '50um',
                              'pad_width': '125um',
                              'pocket_extent': '5um',
                              'pocket_rise': '65um'},
                     'readout': {'cpw_extend': '100um',
                                 'cpw_gap': 'cpw_gap',
                                 'cpw_width': 'cpw_width',
                                 'loc_H': -1,
                                 'loc_W': 1,
                                 'pad_cpw_extent': '25um',
                                 'pad_cpw_shift': '5um',
                                 'pad_gap': '15um',
                                 'pad_height': '30um',
                                 'pad_width': '200um',
                                 'pocket_extent': '5um',
                                 'pocket_rise': '65um'}},
 'pad_width': '425 um',
 'pos_x': '+2.42251mm',
 'pos_y': '+0.0mm'}
)





            # WARNING
#options_connection_pads failed to have a value
Q2 = TransmonPocket(
design,
name='Q2',
options={'connection_pads': {'bus1': {'cpw_extend': '100um',
                              'cpw_gap': 'cpw_gap',
                              'cpw_width': 'cpw_width',
                              'loc_H': 1,
                              'loc_W': -1,
                              'pad_cpw_extent': '25um',
                              'pad_cpw_shift': '5um',
                              'pad_gap': '15um',
                              'pad_height': '30um',
                              'pad_width': '125um',
                              'pocket_extent': '5um',
                              'pocket_rise': '65um'},
                     'bus2': {'cpw_extend': '100um',
                              'cpw_gap': 'cpw_gap',
                              'cpw_width': 'cpw_width',
                              'loc_H': -1,
                              'loc_W': -1,
                              'pad_cpw_extent': '25um',
                              'pad_cpw_shift': '5um',
                              'pad_gap': '15um',
                              'pad_height': '50um',
                              'pad_width': '125um',
                              'pocket_extent': '5um',
                              'pocket_rise': '65um'},
                     'readout': {'cpw_extend': '100um',
                                 'cpw_gap': 'cpw_gap',
                                 'cpw_width': 'cpw_width',
                                 'loc_H': -1,
                                 'loc_W': 1,
                                 'pad_cpw_extent': '25um',
                                 'pad_cpw_shift': '5um',
                                 'pad_gap': '15um',
                                 'pad_height': '30um',
                                 'pad_width': '200um',
                                 'pocket_extent': '5um',
                                 'pocket_rise': '65um'}},
 'orientation': '270',
 'pad_width': '425 um',
 'pos_x': '+0.0mm',
 'pos_y': '-1.2mm'}
)





            # WARNING
#options_connection_pads failed to have a value
Q3 = TransmonPocket(
design,
name='Q3',
options={'connection_pads': {'bus1': {'cpw_extend': '100um',
                              'cpw_gap': 'cpw_gap',
                              'cpw_width': 'cpw_width',
                              'loc_H': 1,
                              'loc_W': -1,
                              'pad_cpw_extent': '25um',
                              'pad_cpw_shift': '5um',
                              'pad_gap': '15um',
                              'pad_height': '30um',
                              'pad_width': '125um',
                              'pocket_extent': '5um',
                              'pocket_rise': '65um'},
                     'bus2': {'cpw_extend': '100um',
                              'cpw_gap': 'cpw_gap',
                              'cpw_width': 'cpw_width',
                              'loc_H': -1,
                              'loc_W': -1,
                              'pad_cpw_extent': '25um',
                              'pad_cpw_shift': '5um',
                              'pad_gap': '15um',
                              'pad_height': '50um',
                              'pad_width': '125um',
                              'pocket_extent': '5um',
                              'pocket_rise': '65um'},
                     'readout': {'cpw_extend': '100um',
                                 'cpw_gap': 'cpw_gap',
                                 'cpw_width': 'cpw_width',
                                 'loc_H': -1,
                                 'loc_W': 1,
                                 'pad_cpw_extent': '25um',
                                 'pad_cpw_shift': '5um',
                                 'pad_gap': '15um',
                                 'pad_height': '30um',
                                 'pad_width': '200um',
                                 'pocket_extent': '5um',
                                 'pocket_rise': '65um'}},
 'orientation': '180',
 'pad_width': '425 um',
 'pos_x': '-2.42251mm',
 'pos_y': '+0.0mm'}
)





            # WARNING
#options_connection_pads failed to have a value
Q4 = TransmonPocket(
design,
name='Q4',
options={'connection_pads': {'bus1': {'cpw_extend': '100um',
                              'cpw_gap': 'cpw_gap',
                              'cpw_width': 'cpw_width',
                              'loc_H': 1,
                              'loc_W': -1,
                              'pad_cpw_extent': '25um',
                              'pad_cpw_shift': '5um',
                              'pad_gap': '15um',
                              'pad_height': '30um',
                              'pad_width': '125um',
                              'pocket_extent': '5um',
                              'pocket_rise': '65um'},
                     'bus2': {'cpw_extend': '100um',
                              'cpw_gap': 'cpw_gap',
                              'cpw_width': 'cpw_width',
                              'loc_H': -1,
                              'loc_W': -1,
                              'pad_cpw_extent': '25um',
                              'pad_cpw_shift': '5um',
                              'pad_gap': '15um',
                              'pad_height': '50um',
                              'pad_width': '125um',
                              'pocket_extent': '5um',
                              'pocket_rise': '65um'},
                     'readout': {'cpw_extend': '100um',
                                 'cpw_gap': 'cpw_gap',
                                 'cpw_width': 'cpw_width',
                                 'loc_H': -1,
                                 'loc_W': 1,
                                 'pad_cpw_extent': '25um',
                                 'pad_cpw_shift': '5um',
                                 'pad_gap': '15um',
                                 'pad_height': '30um',
                                 'pad_width': '200um',
                                 'pocket_extent': '5um',
                                 'pocket_rise': '65um'}},
 'orientation': '90',
 'pad_width': '425 um',
 'pos_x': '+0.0mm',
 'pos_y': '+1.2mm'}
)




cpw1 = RouteMeander(
design,
name='cpw1',
options={'_actual_length': '5.799999999999998 '
                   'mm',
 'fillet': '90um',
 'hfss_wire_bonds': True,
 'lead': {'end_jogged_extension': '',
          'end_straight': '0.2mm',
          'start_jogged_extension': '',
          'start_straight': '0.2mm'},
 'meander': {'asymmetry': '+140um',
             'lead_direction_inverted': 'false',
             'spacing': '200um'},
 'pin_inputs': {'end_pin': {'component': 'Q2',
                            'pin': 'bus1'},
                'start_pin': {'component': 'Q1',
                              'pin': 'bus2'}},
 'total_length': '5.8 mm',
 'trace_gap': '9um',
 'trace_width': '15um'},

type='CPW',
)




cpw2 = RouteMeander(
design,
name='cpw2',
options={'_actual_length': '5.799999999999998 '
                   'mm',
 'fillet': '90um',
 'hfss_wire_bonds': True,
 'lead': {'end_jogged_extension': '',
          'end_straight': '0.2mm',
          'start_jogged_extension': '',
          'start_straight': '0.2mm'},
 'meander': {'asymmetry': '-140um',
             'lead_direction_inverted': 'true',
             'spacing': '200um'},
 'pin_inputs': {'end_pin': {'component': 'Q2',
                            'pin': 'bus2'},
                'start_pin': {'component': 'Q3',
                              'pin': 'bus1'}},
 'total_length': '5.8 mm',
 'trace_gap': '9um',
 'trace_width': '15um'},

type='CPW',
)




cpw3 = RouteMeander(
design,
name='cpw3',
options={'_actual_length': '5.799999999999998 '
                   'mm',
 'fillet': '90um',
 'hfss_wire_bonds': True,
 'lead': {'end_jogged_extension': '',
          'end_straight': '0.2mm',
          'start_jogged_extension': '',
          'start_straight': '0.2mm'},
 'meander': {'asymmetry': '+140um',
             'lead_direction_inverted': 'false',
             'spacing': '200um'},
 'pin_inputs': {'end_pin': {'component': 'Q4',
                            'pin': 'bus1'},
                'start_pin': {'component': 'Q3',
                              'pin': 'bus2'}},
 'total_length': '5.8 mm',
 'trace_gap': '9um',
 'trace_width': '15um'},

type='CPW',
)




cpw4 = RouteMeander(
design,
name='cpw4',
options={'_actual_length': '5.799999999999998 '
                   'mm',
 'fillet': '90um',
 'hfss_wire_bonds': True,
 'lead': {'end_jogged_extension': '',
          'end_straight': '0.2mm',
          'start_jogged_extension': '',
          'start_straight': '0.2mm'},
 'meander': {'asymmetry': '-140um',
             'lead_direction_inverted': 'true',
             'spacing': '200um'},
 'pin_inputs': {'end_pin': {'component': 'Q4',
                            'pin': 'bus2'},
                'start_pin': {'component': 'Q1',
                              'pin': 'bus1'}},
 'total_length': '5.8 mm',
 'trace_gap': '9um',
 'trace_width': '15um'},

type='CPW',
)



gui.rebuild()
gui.autoscale()
        