from PySide2.QtCore import Qt, QObject, Signal, Slot, Property
from PySide2.QtGui import QStandardItemModel

import operator
from functools import reduce

import cryspy

import logging
logging.basicConfig(format="%(asctime)-15s [%(levelname)s] %(filename)s %(funcName)s [%(lineno)d]: %(message)s", level=logging.INFO)

class CryspyCalculator(QObject):
    def __init__(self, main_rcif_path, parent=None):
        super().__init__(parent)
        logging.info("")
        self._cryspy_obj = cryspy.rhochi_read_file(main_rcif_path)
        self._project_dict = {}
        self._app_dict = {}
        self._info_dict = {}
        self._phases_dict = {}
        self._experiments_dict = {}
        self._calculations_dict = {}
        self.setProjectDictFromCryspyObj()

    def setAppDict(self):
        """Set application state"""
        self._app_dict = {
            'name': 'easyDiffraction',
            'version': '0.3.1',
            'url': 'http://easydiffraction.github.io'
        }

    def setInfoDict(self):
        """Set additional project info"""
        self._info_dict = {
            'name': 'Fe3O4',
            'keywords': ['neutron diffraction', 'powder', '1d'],
            'created_date': '',
            'last_modified_date': ''
        }

    def setPhasesDictFromCryspyObj(self):
        """Set phases (sample model tab in GUI)"""
        self._phases_dict.clear()

        for phase in self._cryspy_obj.crystals:

            # Phase label
            self._phases_dict[phase.label] = {}

            # Unit cell parameters
            self._phases_dict[phase.label]['cell'] = {}
            self._phases_dict[phase.label]['cell']['length_a'] = {
                'header': 'a (Å)',
                'tooltip': 'Unit-cell length of the selected structure in angstroms.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Icell_length_.html',
                'value': phase.cell.a.value,
                'error': phase.cell.a.sigma,
                'min': phase.cell.a.value * 0.8,
                'max': phase.cell.a.value * 1.2,
                'constraint': phase.cell.a.constraint,
                'refine': phase.cell.a.refinement }
            self._phases_dict[phase.label]['cell']['length_b'] = {
                'header': 'b (Å)',
                'tooltip': 'Unit-cell length of the selected structure in angstroms.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Icell_length_.html',
                'value': phase.cell.b.value,
                'error': phase.cell.b.sigma,
                'min': phase.cell.b.value * 0.8,
                'max': phase.cell.b.value * 1.2,
                'constraint': phase.cell.b.constraint,
                'refine': phase.cell.b.refinement }
            self._phases_dict[phase.label]['cell']['length_c'] = {
                'header': 'c (Å)',
                'tooltip': 'Unit-cell length of the selected structure in angstroms.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Icell_length_.html',
                'value': phase.cell.c.value,
                'error': phase.cell.c.sigma,
                'min': phase.cell.c.value * 0.8,
                'max': phase.cell.c.value * 1.2,
                'constraint': phase.cell.c.constraint,
                'refine': phase.cell.c.refinement }
            self._phases_dict[phase.label]['cell']['angle_alpha'] = {
                'header': 'alpha (°)',
                'tooltip': 'Unit-cell angle of the selected structure in degrees.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Icell_angle_.html',
                'value': phase.cell.alpha.value,
                'error': phase.cell.alpha.sigma,
                'min': phase.cell.alpha.value * 0.8,
                'max': phase.cell.alpha.value * 1.2,
                'constraint': phase.cell.alpha.constraint,
                'refine': phase.cell.alpha.refinement }
            self._phases_dict[phase.label]['cell']['angle_beta'] = {
                'header': 'beta (°)',
                'tooltip': 'Unit-cell angle of the selected structure in degrees.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Icell_angle_.html',
                'value': phase.cell.beta.value,
                'error': phase.cell.beta.sigma,
                'min': phase.cell.beta.value * 0.8,
                'max': phase.cell.beta.value * 1.2,
                'constraint': phase.cell.beta.constraint,
                'refine': phase.cell.beta.refinement }
            self._phases_dict[phase.label]['cell']['angle_gamma'] = {
                'header': 'gamma (°)',
                'tooltip': 'Unit-cell angle of the selected structure in degrees.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Icell_angle_.html',
                'value': phase.cell.gamma.value,
                'error': phase.cell.gamma.sigma,
                'min': phase.cell.gamma.value * 0.8,
                'max': phase.cell.gamma.value * 1.2,
                'constraint': phase.cell.gamma.constraint,
                'refine': phase.cell.gamma.refinement }

            # Space group
            self._phases_dict[phase.label]['space_group'] = {}
            self._phases_dict[phase.label]['space_group']['crystal_system'] = {
                'header': 'Crystal system',
                'tooltip': 'The name of the system of geometric crystal classes of space groups (crystal system) to which the space group belongs.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Ispace_group_crystal_system.html',
                'value': phase.cell.bravais_lattice }
            self._phases_dict[phase.label]['space_group']['space_group_name_H-M_alt'] = {
                'header': 'Symbol',
                'tooltip': 'The Hermann-Mauguin symbol of space group.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Ispace_group_name_H-M_alt.html',
                'value': phase.space_group.spgr_given_name }
            self._phases_dict[phase.label]['space_group']['space_group_IT_number'] = {
                'header': 'Number',
                'tooltip': 'The number as assigned in International Tables for Crystallography Vol. A.',
                'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Ispace_group_crystal_system.html',
                'value': phase.space_group.spgr_number }
            self._phases_dict[phase.label]['space_group']['origin_choice'] = {
                'header': 'Setting',
                'tooltip': '',
                'url': '',
                'value': phase.space_group.spgr_choice }

            # Atom sites label
            self._phases_dict[phase.label]['atom_site'] = {}
            for label in phase.atom_site.label:
                self._phases_dict[phase.label]['atom_site'][label] = {}
                #phases_dict[phase.label]['atom_site'][label]['label'] = {
                #'header': 'Label',
                #'tooltip': 'A unique identifier for a particular site in the crystal.',
                #'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_label.html',
                #}

            # Atom site type symbol
            for label, type_symbol in zip(phase.atom_site.label, phase.atom_site.type_symbol):
                self._phases_dict[phase.label]['atom_site'][label]['type_symbol'] = {
                    'header': 'Atom',
                    'tooltip': 'A code to identify the atom species occupying this site.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_type_symbol.html',
                    'value': type_symbol }

            # Atom site coordinates
            for label, x, y, z in zip(phase.atom_site.label, phase.atom_site.x, phase.atom_site.y, phase.atom_site.z):
                self._phases_dict[phase.label]['atom_site'][label]['fract_x'] = {
                    'header': 'x',
                    'tooltip': 'Atom-site coordinate as fractions of the unit cell length.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_fract_.html',
                    'value': x.value,
                    'error': x.sigma,
                    'min': x.value * 0.8,
                    'max': x.value * 1.2,
                    'constraint': x.constraint,
                    'refine': x.refinement }
                self._phases_dict[phase.label]['atom_site'][label]['fract_y'] = {
                    'header': 'y',
                    'tooltip': 'Atom-site coordinate as fractions of the unit cell length.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_fract_.html',
                    'value': y.value,
                    'error': y.sigma,
                    'min': y.value * 0.8,
                    'max': y.value * 1.2,
                    'constraint': y.constraint,
                    'refine': y.refinement }
                self._phases_dict[phase.label]['atom_site'][label]['fract_z'] = {
                    'header': 'z',
                    'tooltip': 'Atom-site coordinate as fractions of the unit cell length.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_fract_.html',
                    'value': z.value,
                    'error': z.sigma,
                    'min': z.value * 0.8,
                    'max': z.value * 1.2,
                    'constraint': z.constraint,
                    'refine': z.refinement }

            # Atom site occupancy
            for label, occupancy in zip(phase.atom_site.label, phase.atom_site.occupancy):
                self._phases_dict[phase.label]['atom_site'][label]['occupancy'] = {
                    'header': 'Occupancy',
                    'tooltip': 'The fraction of the atom type present at this site.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_occupancy.html',
                    'value': occupancy.value,
                    'error': occupancy.sigma,
                    'min': occupancy.value * 0.8,
                    'max': occupancy.value * 1.2,
                    'constraint': occupancy.constraint,
                    'refine': occupancy.refinement }

            # Atom site ADP type
            for label, adp_type in zip(phase.atom_site.label, phase.atom_site.adp_type):
                self._phases_dict[phase.label]['atom_site'][label]['adp_type'] = {
                    'header': 'Type',
                    'tooltip': 'A standard code used to describe the type of atomic displacement parameters used for the site.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_adp_type.html',
                    'value': adp_type }

            # Isotropic ADP
            for label, b_iso in zip(phase.atom_site.label, phase.atom_site.b_iso):
                self._phases_dict[phase.label]['atom_site'][label]['B_iso_or_equiv'] = {
                    'header': 'Biso',
                    'tooltip': 'Isotropic atomic displacement parameter, or equivalent isotropic atomic displacement parameter, B(equiv), in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_B_iso_or_equiv.html',
                    'value': b_iso.value,
                    'error': b_iso.sigma,
                    'min': b_iso.value * 0.8,
                    'max': b_iso.value * 1.2,
                    'constraint': b_iso.constraint,
                    'refine': b_iso.refinement }

            # Anisotropic ADP
            for label, u_11, u_22, u_33, u_12, u_13, u_23 in zip(phase.atom_site_aniso.label,
                phase.atom_site_aniso.u_11, phase.atom_site_aniso.u_22, phase.atom_site_aniso.u_33,
                phase.atom_site_aniso.u_12, phase.atom_site_aniso.u_13, phase.atom_site_aniso.u_23):
                self._phases_dict[phase.label]['atom_site'][label]['u_11'] = {
                    'header': 'U11',
                    'tooltip': 'Anisotropic atomic displacement component in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_aniso_U_.html',
                    'value': u_11.value,
                    'error': u_11.sigma,
                    'min': u_11.value * 0.8,
                    'max': u_11.value * 1.2,
                    'constraint': u_11.constraint,
                    'refine': u_11.refinement }
                self._phases_dict[phase.label]['atom_site'][label]['u_22'] = {
                    'header': 'U22',
                    'tooltip': 'Anisotropic atomic displacement component in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_aniso_U_.html',
                    'value': u_22.value,
                    'error': u_22.sigma,
                    'min': u_22.value * 0.8,
                    'max': u_22.value * 1.2,
                    'constraint': u_22.constraint,
                    'refine': u_22.refinement }
                self._phases_dict[phase.label]['atom_site'][label]['u_33'] = {
                    'header': 'U33',
                    'tooltip': 'Anisotropic atomic displacement component in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_aniso_U_.html',
                    'value': u_33.value,
                    'error': u_33.sigma,
                    'min': u_33.value * 0.8,
                    'max': u_33.value * 1.2,
                    'constraint': u_33.constraint,
                    'refine': u_33.refinement }
                self._phases_dict[phase.label]['atom_site'][label]['u_12'] = {
                    'header': 'U12',
                    'tooltip': 'Anisotropic atomic displacement component in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_aniso_U_.html',
                    'value': u_12.value,
                    'error': u_12.sigma,
                    'min': u_12.value * 0.8,
                    'max': u_12.value * 1.2,
                    'constraint': u_12.constraint,
                    'refine': u_12.refinement }
                self._phases_dict[phase.label]['atom_site'][label]['u_13'] = {
                    'header': 'U13',
                    'tooltip': 'Anisotropic atomic displacement component in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_aniso_U_.html',
                    'value': u_13.value,
                    'error': u_13.sigma,
                    'min': u_13.value * 0.8,
                    'max': u_13.value * 1.2,
                    'constraint': u_13.constraint,
                    'refine': u_13.refinement }
                self._phases_dict[phase.label]['atom_site'][label]['u_23'] = {
                    'header': 'U23',
                    'tooltip': 'Anisotropic atomic displacement component in angstroms squared.',
                    'url': 'https://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Iatom_site_aniso_U_.html',
                    'value': u_23.value,
                    'error': u_23.sigma,
                    'min': u_23.value * 0.8,
                    'max': u_23.value * 1.2,
                    'constraint': u_23.constraint,
                    'refine': u_23.refinement }

            # Anisotropic MSP
            for label, chi_11, chi_22, chi_33, chi_12, chi_13, chi_23 in zip(phase.atom_site_magnetism_aniso.label,
                phase.atom_site_magnetism_aniso.chi_11, phase.atom_site_magnetism_aniso.chi_22, phase.atom_site_magnetism_aniso.chi_33,
                phase.atom_site_magnetism_aniso.chi_12, phase.atom_site_magnetism_aniso.chi_13, phase.atom_site_magnetism_aniso.chi_23):
                self._phases_dict[phase.label]['atom_site'][label]['chi_11'] = {
                    'header': 'Chi11',
                    'tooltip': '',
                    'url': '',
                    'value': chi_11.value,
                    'error': chi_11.sigma,
                    'min': chi_11.value * 0.8,
                    'max': chi_11.value * 1.2,
                    'constraint': chi_11.constraint,
                    'refine': chi_11.refinement }
                self._phases_dict[phase.label]['atom_site'][label]['chi_22'] = {
                    'header': 'Chi22',
                    'tooltip': '',
                    'url': '',
                    'value': chi_22.value,
                    'error': chi_22.sigma,
                    'min': chi_22.value * 0.8,
                    'max': chi_22.value * 1.2,
                    'constraint': chi_22.constraint,
                    'refine': chi_22.refinement }
                self._phases_dict[phase.label]['atom_site'][label]['chi_33'] = {
                    'header': 'Chi33',
                    'tooltip': '',
                    'url': '',
                    'value': chi_33.value,
                    'error': chi_33.sigma,
                    'min': chi_33.value * 0.8,
                    'max': chi_33.value * 1.2,
                    'constraint': chi_33.constraint,
                    'refine': chi_33.refinement }
                self._phases_dict[phase.label]['atom_site'][label]['chi_12'] = {
                    'header': 'Chi12',
                    'tooltip': '',
                    'url': '',
                    'value': chi_12.value,
                    'error': chi_12.sigma,
                    'min': chi_12.value * 0.8,
                    'max': chi_12.value * 1.2,
                    'constraint': chi_12.constraint,
                    'refine': chi_12.refinement }
                self._phases_dict[phase.label]['atom_site'][label]['chi_13'] = {
                    'header': 'Chi13',
                    'tooltip': '',
                    'url': '',
                    'value': chi_13.value,
                    'error': chi_13.sigma,
                    'min': chi_13.value * 0.8,
                    'max': chi_13.value * 1.2,
                    'constraint': chi_13.constraint,
                    'refine': chi_13.refinement }
                self._phases_dict[phase.label]['atom_site'][label]['chi_23'] = {
                    'header': 'Chi23',
                    'tooltip': '',
                    'url': '',
                    'value': chi_23.value,
                    'error': chi_23.sigma,
                    'min': chi_23.value * 0.8,
                    'max': chi_23.value * 1.2,
                    'constraint': chi_23.constraint,
                    'refine': chi_23.refinement }

    def setExperimentsDictFromCryspyObj(self):
        """Set experiments (Experimental data tab in GUI)"""
        self._experiments_dict.clear()

        for experiment in self._cryspy_obj.experiments:

            # Experiment label
            self._experiments_dict[experiment.label] = {}

            # Main parameters
            self._experiments_dict[experiment.label]['wavelength'] = {
                'header': 'Wavelength (Å)',
                'tooltip': '',
                'url': '',
                'value': experiment.wavelength }
            self._experiments_dict[experiment.label]['offset'] = {
                'header': '',
                'tooltip': '',
                'url': '',
                'value': experiment.offset.value,
                'error': experiment.offset.sigma,
                'min': experiment.offset.value * 0.8,
                'max': experiment.offset.value * 1.2,
                'constraint': experiment.offset.constraint,
                'refine': experiment.offset.refinement }

            # Scale
            # ONLY 1st scale parameter is currently taken into account!!!
            self._experiments_dict[experiment.label]['phase'] = {}
            self._experiments_dict[experiment.label]['phase']['scale'] = {
                'header': '',
                'tooltip': '',
                'url': '',
                'value': experiment.phase.scale[0].value,
                'error': experiment.phase.scale[0].sigma,
                'min': experiment.phase.scale[0].value * 0.8,
                'max': experiment.phase.scale[0].value * 1.2,
                'constraint': experiment.phase.scale[0].constraint,
                'refine': experiment.phase.scale[0].refinement }

            # Background
            self._experiments_dict[experiment.label]['background'] = {}
            for ttheta, intensity in zip(experiment.background.ttheta, experiment.background.intensity):
                index = str(ttheta)
                self._experiments_dict[experiment.label]['background'][index] = {}
                self._experiments_dict[experiment.label]['background'][index]['ttheta'] = ttheta
                self._experiments_dict[experiment.label]['background'][index]['intensity'] = {
                    'value': intensity.value,
                    'error': intensity.sigma,
                    'min': intensity.value * 0.8,
                    'max': intensity.value * 1.2,
                    'constraint': intensity.constraint,
                    'refine': intensity.refinement }

            # Instrument resolution
            self._experiments_dict[experiment.label]['resolution'] = {}
            self._experiments_dict[experiment.label]['resolution']['u'] = {
                'header': 'U',
                'tooltip': '',
                'url': '',
                'value': experiment.resolution.u.value,
                'error': experiment.resolution.u.sigma,
                'min': experiment.resolution.u.value * 0.8,
                'max': experiment.resolution.u.value * 1.2,
                'constraint': experiment.resolution.u.constraint,
                'refine': experiment.resolution.u.refinement }
            self._experiments_dict[experiment.label]['resolution']['v'] = {
                'header': 'V',
                'tooltip': '',
                'url': '',
                'value': experiment.resolution.v.value,
                'error': experiment.resolution.v.sigma,
                'min': experiment.resolution.v.value * 0.8,
                'max': experiment.resolution.v.value * 1.2,
                'constraint': experiment.resolution.v.constraint,
                'refine': experiment.resolution.v.refinement }
            self._experiments_dict[experiment.label]['resolution']['w'] = {
                'header': 'W',
                'tooltip': '',
                'url': '',
                'value': experiment.resolution.w.value,
                'error': experiment.resolution.w.sigma,
                'min': experiment.resolution.w.value * 0.8,
                'max': experiment.resolution.w.value * 1.2,
                'constraint': experiment.resolution.w.constraint,
                'refine': experiment.resolution.w.refinement }
            self._experiments_dict[experiment.label]['resolution']['x'] = {
                'header': 'X',
                'tooltip': '',
                'url': '',
                'value': experiment.resolution.x.value,
                'error': experiment.resolution.x.sigma,
                'min': experiment.resolution.x.value * 0.8,
                'max': experiment.resolution.x.value * 1.2,
                'constraint': experiment.resolution.x.constraint,
                'refine': experiment.resolution.x.refinement }
            self._experiments_dict[experiment.label]['resolution']['y'] = {
                'header': 'Y',
                'tooltip': '',
                'url': '',
                'value': experiment.resolution.y.value,
                'error': experiment.resolution.y.sigma,
                'min': experiment.resolution.y.value * 0.8,
                'max': experiment.resolution.y.value * 1.2,
                'constraint': experiment.resolution.y.constraint,
                'refine': experiment.resolution.y.refinement }

            # Measured data points
            self._experiments_dict[experiment.label]['measured'] = {}
            self._experiments_dict[experiment.label]['measured']['ttheta'] = experiment.meas.ttheta.tolist()
            self._experiments_dict[experiment.label]['measured']['up'] = experiment.meas.up.tolist()
            self._experiments_dict[experiment.label]['measured']['up_sigma'] = experiment.meas.up_sigma.tolist()
            self._experiments_dict[experiment.label]['measured']['down'] = experiment.meas.down.tolist()
            self._experiments_dict[experiment.label]['measured']['down_sigma'] = experiment.meas.down_sigma.tolist()

    def setCalculationsDictFromCryspyObj(self):
        """Set calculated data (depends on phases and experiments from above)"""
        self._calculations_dict.clear()

        for experiment in self._cryspy_obj.experiments:

            # Experiment label
            self._calculations_dict[experiment.label] = {}

            # Calculated chi squared and number of data points used for refinement
            logging.info("calc_chi_sq start") # profiling
            chi_sq, n_res = experiment.calc_chi_sq(self._cryspy_obj.crystals)
            logging.info("calc_chi_sq end") # profiling

            # Main parameters
            self._calculations_dict[experiment.label]['chi_squared'] = {
                'header': '',
                'tooltip': '',
                'url': '',
                'value': float(chi_sq) }
            self._calculations_dict[experiment.label]['n_res'] = {
                'header': '',
                'tooltip': '',
                'url': '',
                'value': int(n_res) }

            # Calculated data
            logging.info("calc_profile start") # profiling
            calculated_pattern, bragg_peaks, _ = experiment.calc_profile(experiment.meas.ttheta, self._cryspy_obj.crystals)
            logging.info("calc_profile end") # profiling

            # Bragg peaks
            self._calculations_dict[experiment.label]['bragg_peaks'] = {}
            for index, crystal in enumerate(self._cryspy_obj.crystals):
                self._calculations_dict[experiment.label]['bragg_peaks'][crystal.label] = {
                    'h': bragg_peaks[index].h.tolist(),
                    'k': bragg_peaks[index].k.tolist(),
                    'l': bragg_peaks[index].l.tolist(),
                    'ttheta': bragg_peaks[index].ttheta.tolist()
                }

            # Calculated diffraction pattern
            self._calculations_dict[experiment.label]['calculated_pattern'] = {
                'ttheta': calculated_pattern.ttheta.tolist(),
                'up_total': calculated_pattern.up_total.tolist(),
                'down_total': calculated_pattern.down_total.tolist()
            }

    def setProjectDictFromCryspyObj(self):
        """Combine all the data to one project dictionary"""
        self.setAppDict()
        self.setInfoDict()
        self.setPhasesDictFromCryspyObj()
        self.setExperimentsDictFromCryspyObj()
        self.setCalculationsDictFromCryspyObj()
        self._project_dict = {
            'app': self._app_dict,
            'info': self._info_dict,
            'phases': self._phases_dict,
            'experiments': self._experiments_dict,
            'calculations': self._calculations_dict,
        }

    def setCryspyObjFromPhases(self):
        """Set phases (sample model tab in GUI)"""
        for phase in self._cryspy_obj.crystals:

            # Unit cell parameters
            phase.cell.a.value = self._phases_dict[phase.label]['cell']['length_a']['value']
            phase.cell.b.value = self._phases_dict[phase.label]['cell']['length_b']['value']
            phase.cell.c.value = self._phases_dict[phase.label]['cell']['length_c']['value']
            phase.cell.a.refinement = self._phases_dict[phase.label]['cell']['length_a']['refine']
            phase.cell.b.refinement = self._phases_dict[phase.label]['cell']['length_b']['refine']
            phase.cell.c.refinement = self._phases_dict[phase.label]['cell']['length_c']['refine']

            # Atom site coordinates
            for label, x, y, z in zip(phase.atom_site.label, phase.atom_site.x, phase.atom_site.y, phase.atom_site.z):
                x.value = self._phases_dict[phase.label]['atom_site'][label]['fract_x']['value']
                y.value = self._phases_dict[phase.label]['atom_site'][label]['fract_y']['value']
                z.value = self._phases_dict[phase.label]['atom_site'][label]['fract_z']['value']
                x.refinement = self._phases_dict[phase.label]['atom_site'][label]['fract_x']['refine']
                y.refinement = self._phases_dict[phase.label]['atom_site'][label]['fract_y']['refine']
                z.refinement = self._phases_dict[phase.label]['atom_site'][label]['fract_z']['refine']

            # Atom site occupancy
            for label, occupancy in zip(phase.atom_site.label, phase.atom_site.occupancy):
                occupancy.value = self._phases_dict[phase.label]['atom_site'][label]['occupancy']['value']
                occupancy.refine = self._phases_dict[phase.label]['atom_site'][label]['occupancy']['refine']

            # Isotropic ADP
            for label, b_iso in zip(phase.atom_site.label, phase.atom_site.b_iso):
                b_iso.value = self._phases_dict[phase.label]['atom_site'][label]['B_iso_or_equiv']['value']
                b_iso.refine = self._phases_dict[phase.label]['atom_site'][label]['B_iso_or_equiv']['refine']

            #
            # Anisotropic ADP
            for label, u_11, u_22, u_33, u_12, u_13, u_23 in zip(phase.atom_site_aniso.label,
                phase.atom_site_aniso.u_11, phase.atom_site_aniso.u_22, phase.atom_site_aniso.u_33,
                phase.atom_site_aniso.u_12, phase.atom_site_aniso.u_13, phase.atom_site_aniso.u_23):
                    u_11.value = self._phases_dict[phase.label]['atom_site'][label]['u_11']['value']
                    u_22.value = self._phases_dict[phase.label]['atom_site'][label]['u_22']['value']
                    u_33.value = self._phases_dict[phase.label]['atom_site'][label]['u_33']['value']
                    u_12.value = self._phases_dict[phase.label]['atom_site'][label]['u_12']['value']
                    u_13.value = self._phases_dict[phase.label]['atom_site'][label]['u_13']['value']
                    u_23.value = self._phases_dict[phase.label]['atom_site'][label]['u_23']['value']
                    u_11.refine = self._phases_dict[phase.label]['atom_site'][label]['u_11']['refine']
                    u_22.refine = self._phases_dict[phase.label]['atom_site'][label]['u_22']['refine']
                    u_33.refine = self._phases_dict[phase.label]['atom_site'][label]['u_33']['refine']
                    u_12.refine = self._phases_dict[phase.label]['atom_site'][label]['u_12']['refine']
                    u_13.refine = self._phases_dict[phase.label]['atom_site'][label]['u_13']['refine']
                    u_23.refine = self._phases_dict[phase.label]['atom_site'][label]['u_23']['refine']

            # Anisotropic MSP
            for label, chi_11, chi_22, chi_33, chi_12, chi_13, chi_23 in zip(phase.atom_site_magnetism_aniso.label,
                phase.atom_site_magnetism_aniso.chi_11, phase.atom_site_magnetism_aniso.chi_22, phase.atom_site_magnetism_aniso.chi_33,
                phase.atom_site_magnetism_aniso.chi_12, phase.atom_site_magnetism_aniso.chi_13, phase.atom_site_magnetism_aniso.chi_23):
                    chi_11.value = self._phases_dict[phase.label]['atom_site'][label]['chi_11']['value']
                    chi_22.value = self._phases_dict[phase.label]['atom_site'][label]['chi_22']['value']
                    chi_33.value = self._phases_dict[phase.label]['atom_site'][label]['chi_33']['value']
                    chi_12.value = self._phases_dict[phase.label]['atom_site'][label]['chi_12']['value']
                    chi_13.value = self._phases_dict[phase.label]['atom_site'][label]['chi_13']['value']
                    chi_23.value = self._phases_dict[phase.label]['atom_site'][label]['chi_23']['value']
                    chi_11.refinement = self._phases_dict[phase.label]['atom_site'][label]['chi_11']['refine']
                    chi_22.refinement = self._phases_dict[phase.label]['atom_site'][label]['chi_22']['refine']
                    chi_33.refinement = self._phases_dict[phase.label]['atom_site'][label]['chi_33']['refine']
                    chi_12.refinement = self._phases_dict[phase.label]['atom_site'][label]['chi_12']['refine']
                    chi_13.refinement = self._phases_dict[phase.label]['atom_site'][label]['chi_13']['refine']
                    chi_23.refinement = self._phases_dict[phase.label]['atom_site'][label]['chi_23']['refine']

    def setCryspyObjFromExperiments(self):
        """Set experiments (Experimental data tab in GUI)"""
        for experiment in self._cryspy_obj.experiments:

            # Main parameters
            experiment.offset.value = self._experiments_dict[experiment.label]['offset']['value']
            experiment.offset.refinement = self._experiments_dict[experiment.label]['offset']['refine']

            # Scale
            # ONLY 1st scale parameter is currently taken into account!!!
            experiment.phase.scale[0].value = self._experiments_dict[experiment.label]['phase']['scale']['value']
            experiment.phase.scale[0].refinement = self._experiments_dict[experiment.label]['phase']['scale']['refine']

            # Background
            for ttheta, intensity in zip(experiment.background.ttheta, experiment.background.intensity):
                index = str(ttheta)
                intensity.value = self._experiments_dict[experiment.label]['background'][index]['intensity']['value']
                intensity.refinement = self._experiments_dict[experiment.label]['background'][index]['intensity']['refine']

            # Instrument resolution
            experiment.resolution.u.value = self._experiments_dict[experiment.label]['resolution']['u']['value']
            experiment.resolution.v.value = self._experiments_dict[experiment.label]['resolution']['v']['value']
            experiment.resolution.w.value = self._experiments_dict[experiment.label]['resolution']['w']['value']
            experiment.resolution.x.value = self._experiments_dict[experiment.label]['resolution']['x']['value']
            experiment.resolution.y.value = self._experiments_dict[experiment.label]['resolution']['y']['value']
            experiment.resolution.u.refinement = self._experiments_dict[experiment.label]['resolution']['u']['refine']
            experiment.resolution.v.refinement = self._experiments_dict[experiment.label]['resolution']['v']['refine']
            experiment.resolution.w.refinement = self._experiments_dict[experiment.label]['resolution']['w']['refine']
            experiment.resolution.x.refinement = self._experiments_dict[experiment.label]['resolution']['x']['refine']
            experiment.resolution.y.refinement = self._experiments_dict[experiment.label]['resolution']['y']['refine']

    def setCryspyObjFromProjectDict(self):
        """Set all the cryspy parameters from project dictionary"""
        self.setCryspyObjFromPhases()
        self.setCryspyObjFromExperiments()

    projectDictChanged = Signal()

    def getByPath(self, keys):
        """Access a nested object in root by key sequence."""
        return reduce(operator.getitem, keys, self._project_dict)

    def setByPath(self, keys, value):
        """Get a value in a nested object in root by key sequence."""
        self.getByPath(keys[:-1])[keys[-1]] = value
        self.setCryspyObjFromProjectDict() # updates value in cryspy obj (actually all values, which is too expensive...)
        if not isinstance(value, bool):
            self.setCalculationsDictFromCryspyObj() # updates back calculated curve, if something is changed but Fit checkBox
        self.projectDictChanged.emit()

    def phasesCount(self):
        """Returns number of phases in the project."""
        return len(self._project_dict['phases'].keys())

    def experimentsCount(self):
        """Returns number of experiments in the project."""
        return len(self._project_dict['experiments'].keys())

    def phasesIds(self):
        """Returns labels of the phases in the project."""
        return list(self._project_dict['phases'].keys())

    def experimentsIds(self):
        """Returns labels of the experiments in the project."""
        return list(self._project_dict['experiments'].keys())

    def asDict(self):
        """Return data dict."""
        return self._project_dict

    def refine(self):
        """refinement ..."""
        scipy_refinement_res = self._cryspy_obj.refine()
        self.setProjectDictFromCryspyObj()
        self.projectDictChanged.emit()
        try:
            return {
                "refinement_message":scipy_refinement_res.message,
                "nfev":scipy_refinement_res.nfev,
                "nit":scipy_refinement_res.nit,
                "njev":scipy_refinement_res.njev,
                "final_chi_sq":float(scipy_refinement_res.fun),
            }
        except:
             return { "refinement_message":"Unknow problems during refinement" }
