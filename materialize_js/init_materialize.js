import { materializeAutocomplete } from "./materialize/autocomplete";
import { materializeCarousel } from "./materialize/carousel";
import { materializeCharactercounter } from "./materialize/charactercounter";
import { materializeChips } from "./materialize/chips";
import { materializeCollapsible } from "./materialize/collapsible";
import { materializeDatePicker } from "./materialize/datepicker";
import { materializeDropdown } from "./materialize/dropdown";
import { materializeFeatureDiscovery } from "./materialize/featurediscovery";
import { materializeFloatingActionButton } from "./materialize/floatingactionbutton";
import { materializeMedia } from "./materialize/media";
import { materializeModal } from "./materialize/modal";
import { materializeParallax } from "./materialize/parallax";
import { materializePushpin } from "./materialize/pushpin";
import { materializeScrollspy } from "./materialize/scrollspy";
import { materializeSelect } from "./materialize/select";
import { materializeSidenav } from "./materialize/sidenav";
import { materializeTabs } from "./materialize/tabs";
import { materializeTimePicker } from "./materialize/timepicker";
import { materializeTooltips } from "./materialize/tooltips";

const initMaterialize = () => {
	materializeAutocomplete();
	materializeCarousel();
	materializeCharactercounter();
	materializeChips();
	materializeCollapsible();
	materializeDatePicker();
	materializeDropdown();
	materializeFeatureDiscovery();
	materializeFloatingActionButton();
	materializeMedia();
	materializeModal();
	materializeParallax();
	materializePushpin();
	materializeScrollspy();
	materializeSelect();
	materializeSidenav();
	materializeTabs();
	materializeTimePicker();
	materializeTooltips();
};

export { initMaterialize };
