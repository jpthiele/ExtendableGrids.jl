# 2D Grid examples
# ===============
# 

# ## Rectangle
function rectangle()
    X=collect(0:0.05:1)
    Y=collect(0:0.05:1)
    simplexgrid(X,X)
end
# ![](rectangle.svg)
# 
# ## Rectangle with local refinement
# 
function rectangle_localref()
    hmin=0.01
    hmax=0.1
    XLeft=geomspace(0.0,0.5,hmax,hmin)
    XRight=geomspace(0.5,1.0,hmin,hmax)
    X=glue(XLeft, XRight)
    simplexgrid(X,X)
end
# ![](rectangle_localref.svg)


# 
# ## Rectangle with multiple regions
# 
function rectangle_multiregion()
    X=collect(0:0.05:1)
    Y=collect(0:0.05:1)
    grid=simplexgrid(X,Y)
    cellmask!(grid,[0.0,0.0],[1.0,0.5],3)
    bfacemask!(grid,[0.0,0.0],[0.0,0.5],5)
    bfacemask!(grid,[1.0,0.0],[1.0,0.5],6)
    bfacemask!(grid,[0.0,0.5],[1.0,0.5],7)
end
# ![](rectangle_multiregion.svg)



# 
# ## Subgrid from rectangle
# 
function rectangle_subgrid()
    X=collect(0:0.05:1)
    Y=collect(0:0.05:1)
    grid=simplexgrid(X,Y)
    rect!(grid,[0.25,0.25],[0.75,0.75];region=2, bregion=5)
    subgrid(grid,[1])
end
# ![](rectangle_subgrid.svg)


# 
# ## Rect2d with bregion function
#
# Here, we use function as bregion parameter - this allows to
# have no bfaces at the interface between the two rects.
function rect2d_bregion_function()
    X=collect(0:0.5:10)
    Y=collect(0:0.5:10)
    grid=simplexgrid(X,Y)
    rect!(grid,[5,4],[9,6];region=2, bregions=[5,5,5,5])

    rect!(grid,[4,2],[5,8];region=2, bregion= cur-> cur == 5  ? 0 : 8   )
    
    subgrid(grid,[2])
    
end
# ![](rect2d_bregion_function.svg)




function sorted_subgrid(; maxvolume=0.01)
    
    builder=SimplexGridBuilder(Generator=Triangulate)
    
    p1=point!(builder,0,0)
    p2=point!(builder,1,0)
    p3=point!(builder,1,2)
    p4=point!(builder,0,1)
    p5=point!(builder,-1,2)

    facetregion!(builder,1)
    facet!(builder,p1,p2)
    facetregion!(builder,2)
    facet!(builder,p2,p3)
    facetregion!(builder,3)
    facet!(builder,p3,p4)
    facetregion!(builder,4)
    facet!(builder,p4,p5)
    facetregion!(builder,5)
    facet!(builder,p5,p1)

    g=simplexgrid(builder;maxvolume)
    sg=subgrid(g,[2],boundary=true,transform=(a,b)->a[1]=b[2])
    f=map( (x,y)->sin(3x)*cos(3y),g)
    sf=view(f,sg)
    g,sg,sf
end
# ![](sorted_subgrid.svg)

