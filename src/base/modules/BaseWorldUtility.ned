package org.mixim.base.modules;

//World Utility interface for whole network informations. 
moduleinterface IWorldUtility
{
    parameters:
        double playgroundSizeX @unit(m);    // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m);    // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m);    // z size of the area the nodes are in (in meters)
        bool   useTorus;                    // use the playground as torus?
        @display("i=misc/globe");
}
 
// Basic utility module for the whole network.
// Provides utility methods and information used by
// the whole network.
simple BaseWorldUtility like IWorldUtility
{
    parameters:
        @class(BaseWorldUtility);
        double playgroundSizeX @unit(m); // x size of the area the nodes are in (in meters)
        double playgroundSizeY @unit(m); // y size of the area the nodes are in (in meters)
        double playgroundSizeZ @unit(m); // z size of the area the nodes are in (in meters)
        bool useTorus = default(false);  // use the playground as torus?
        @display("i=misc/globe");
}

