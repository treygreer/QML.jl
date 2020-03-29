ENV["QSG_RENDER_LOOP"] = "basic" # multithreading in Qt must be off
using CxxWrap # for safe_cfunction
using QML
using Observables

# Set up plots with GR so QPainter can be used directly
using Plots
ENV["GKSwstype"] = "nul"
gr(show=true)

const qmlfile = joinpath(dirname(Base.source_path()), "qml", "gr.qml")

f = Observable(1.0)
A = Observable(1.0)

# Arguments here need to be the "reference types", hence the "Ref" suffix
function paint(p::CxxPtr{QPainter}, item::CxxPtr{JuliaPaintedItem})  
  ENV["GKS_WSTYPE"] = 381
    ENV["GKS_CONID"] = split(repr(p.cpp_object), "@")[2]
    println("GKS_CONID = $(ENV["GKS_CONID"])")

  dev = device(p[])[]
  r = effectiveDevicePixelRatio(window(item[])[])
  w, h = width(dev) / r, height(dev) / r

  x = 0:π/100:π
  y = A[]*sin.(f[]*x)

  plot(x, y, ylims=(-5,5), size=(w, h))

  return
end

load(qmlfile,
  paint_cfunction = @safe_cfunction(paint, Cvoid, (CxxPtr{QPainter}, CxxPtr{JuliaPaintedItem})),
  frequency = f,
  amplitude = A
)
exec()

"""
Example of GR.jl integration
"""
