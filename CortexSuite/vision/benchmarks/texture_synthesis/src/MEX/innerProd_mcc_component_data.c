/*
 * MATLAB Compiler: 4.4 (R2006a)
 * Date: Thu Jul 24 17:19:07 2008
 * Arguments: "-B" "macro_default" "-m" "-W" "main" "-T" "link:exe" "-d"
 * "../MEX" "innerProd.m" 
 */

#include "mclmcr.h"

#ifdef __cplusplus
extern "C" {
#endif
const unsigned char __MCC_innerProd_session_key[] = {
        'B', 'C', 'C', '8', 'A', 'E', 'C', 'F', '0', '7', '5', '2', 'D', 'F',
        'F', '9', '4', '2', '0', 'B', '6', 'F', '5', 'B', 'E', 'A', 'E', '4',
        'C', '2', 'F', '5', '4', 'D', '1', '4', '6', '3', 'B', 'A', '5', '1',
        'D', '8', '3', '7', 'F', '5', '4', '6', 'C', '1', 'D', 'B', '9', '3',
        'C', 'D', 'A', 'D', 'F', '3', '5', 'F', '5', 'A', '2', 'D', '9', 'A',
        '4', '4', '6', 'D', 'C', '5', '3', '7', '7', '5', '7', '2', '3', '0',
        'E', '2', 'E', '7', '0', 'F', '7', '4', 'B', 'A', '8', 'B', '9', '8',
        '5', '8', 'D', 'D', '3', '3', '3', '7', '9', 'E', '8', '1', '3', '9',
        '1', '2', 'A', '6', 'B', '0', '4', '8', 'F', 'D', '9', 'D', '3', '5',
        '2', '8', '4', '3', '7', '3', '1', 'D', '7', '0', 'E', '0', '0', '3',
        'D', '9', '7', '3', '0', 'F', '8', '7', '0', 'C', 'A', 'B', '4', '1',
        'F', '0', '4', '5', 'E', '1', '7', '4', 'C', 'E', '6', 'A', 'C', 'D',
        'C', '6', 'F', '8', '6', '5', 'F', '5', '1', 'A', '6', '9', 'F', 'E',
        '7', '9', 'A', '3', 'E', '7', 'C', '6', '2', '3', '7', 'C', 'E', '9',
        'A', '0', '6', '3', '5', '9', '3', '4', '1', '5', '9', 'D', '9', '2',
        '4', 'B', '1', '0', '6', '0', 'A', '3', '5', '8', '2', '1', '8', '4',
        'E', 'B', 'C', 'D', 'B', '6', '4', '7', 'F', 'D', '9', 'A', '3', '3',
        'D', '0', '1', '5', 'C', '2', '1', 'B', '5', 'C', '1', '5', '9', '3',
        '0', '4', '6', '1', '\0'};

const unsigned char __MCC_innerProd_public_key[] = {
        '3', '0', '8', '1', '9', 'D', '3', '0', '0', 'D', '0', '6', '0', '9',
        '2', 'A', '8', '6', '4', '8', '8', '6', 'F', '7', '0', 'D', '0', '1',
        '0', '1', '0', '1', '0', '5', '0', '0', '0', '3', '8', '1', '8', 'B',
        '0', '0', '3', '0', '8', '1', '8', '7', '0', '2', '8', '1', '8', '1',
        '0', '0', 'C', '4', '9', 'C', 'A', 'C', '3', '4', 'E', 'D', '1', '3',
        'A', '5', '2', '0', '6', '5', '8', 'F', '6', 'F', '8', 'E', '0', '1',
        '3', '8', 'C', '4', '3', '1', '5', 'B', '4', '3', '1', '5', '2', '7',
        '7', 'E', 'D', '3', 'F', '7', 'D', 'A', 'E', '5', '3', '0', '9', '9',
        'D', 'B', '0', '8', 'E', 'E', '5', '8', '9', 'F', '8', '0', '4', 'D',
        '4', 'B', '9', '8', '1', '3', '2', '6', 'A', '5', '2', 'C', 'C', 'E',
        '4', '3', '8', '2', 'E', '9', 'F', '2', 'B', '4', 'D', '0', '8', '5',
        'E', 'B', '9', '5', '0', 'C', '7', 'A', 'B', '1', '2', 'E', 'D', 'E',
        '2', 'D', '4', '1', '2', '9', '7', '8', '2', '0', 'E', '6', '3', '7',
        '7', 'A', '5', 'F', 'E', 'B', '5', '6', '8', '9', 'D', '4', 'E', '6',
        '0', '3', '2', 'F', '6', '0', 'C', '4', '3', '0', '7', '4', 'A', '0',
        '4', 'C', '2', '6', 'A', 'B', '7', '2', 'F', '5', '4', 'B', '5', '1',
        'B', 'B', '4', '6', '0', '5', '7', '8', '7', '8', '5', 'B', '1', '9',
        '9', '0', '1', '4', '3', '1', '4', 'A', '6', '5', 'F', '0', '9', '0',
        'B', '6', '1', 'F', 'C', '2', '0', '1', '6', '9', '4', '5', '3', 'B',
        '5', '8', 'F', 'C', '8', 'B', 'A', '4', '3', 'E', '6', '7', '7', '6',
        'E', 'B', '7', 'E', 'C', 'D', '3', '1', '7', '8', 'B', '5', '6', 'A',
        'B', '0', 'F', 'A', '0', '6', 'D', 'D', '6', '4', '9', '6', '7', 'C',
        'B', '1', '4', '9', 'E', '5', '0', '2', '0', '1', '1', '1', '\0'};

static const char * MCC_innerProd_matlabpath_data[] = 
    { "innerProd/", "toolbox/compiler/deploy/", "$TOOLBOXMATLABDIR/general/",
      "$TOOLBOXMATLABDIR/ops/", "$TOOLBOXMATLABDIR/lang/",
      "$TOOLBOXMATLABDIR/elmat/", "$TOOLBOXMATLABDIR/elfun/",
      "$TOOLBOXMATLABDIR/specfun/", "$TOOLBOXMATLABDIR/matfun/",
      "$TOOLBOXMATLABDIR/datafun/", "$TOOLBOXMATLABDIR/polyfun/",
      "$TOOLBOXMATLABDIR/funfun/", "$TOOLBOXMATLABDIR/sparfun/",
      "$TOOLBOXMATLABDIR/scribe/", "$TOOLBOXMATLABDIR/graph2d/",
      "$TOOLBOXMATLABDIR/graph3d/", "$TOOLBOXMATLABDIR/specgraph/",
      "$TOOLBOXMATLABDIR/graphics/", "$TOOLBOXMATLABDIR/uitools/",
      "$TOOLBOXMATLABDIR/strfun/", "$TOOLBOXMATLABDIR/imagesci/",
      "$TOOLBOXMATLABDIR/iofun/", "$TOOLBOXMATLABDIR/audiovideo/",
      "$TOOLBOXMATLABDIR/timefun/", "$TOOLBOXMATLABDIR/datatypes/",
      "$TOOLBOXMATLABDIR/verctrl/", "$TOOLBOXMATLABDIR/codetools/",
      "$TOOLBOXMATLABDIR/helptools/", "$TOOLBOXMATLABDIR/demos/",
      "$TOOLBOXMATLABDIR/timeseries/", "$TOOLBOXMATLABDIR/hds/",
      "$TOOLBOXMATLABDIR/guide/", "$TOOLBOXMATLABDIR/plottools/",
      "toolbox/local/", "toolbox/compiler/", "toolbox/database/database/" };

static const char * MCC_innerProd_classpath_data[] = 
    { "java/jar/toolbox/database.jar" };

static const char * MCC_innerProd_libpath_data[] = 
    { "" };

static const char * MCC_innerProd_app_opts_data[] = 
    { "" };

static const char * MCC_innerProd_run_opts_data[] = 
    { "" };

static const char * MCC_innerProd_warning_state_data[] = 
    { "" };


mclComponentData __MCC_innerProd_component_data = { 

    /* Public key data */
    __MCC_innerProd_public_key,

    /* Component name */
    "innerProd",

    /* Component Root */
    "",

    /* Application key data */
    __MCC_innerProd_session_key,

    /* Component's MATLAB Path */
    MCC_innerProd_matlabpath_data,

    /* Number of directories in the MATLAB Path */
    36,

    /* Component's Java class path */
    MCC_innerProd_classpath_data,
    /* Number of directories in the Java class path */
    1,

    /* Component's load library path (for extra shared libraries) */
    MCC_innerProd_libpath_data,
    /* Number of directories in the load library path */
    0,

    /* MCR instance-specific runtime options */
    MCC_innerProd_app_opts_data,
    /* Number of MCR instance-specific runtime options */
    0,

    /* MCR global runtime options */
    MCC_innerProd_run_opts_data,
    /* Number of MCR global runtime options */
    0,
    
    /* Component preferences directory */
    "innerProd_EEEFF7AADF2C5D8569D4742763DAC0AB",

    /* MCR warning status data */
    MCC_innerProd_warning_state_data,
    /* Number of MCR warning status modifiers */
    0,

    /* Path to component - evaluated at runtime */
    NULL

};

#ifdef __cplusplus
}
#endif


