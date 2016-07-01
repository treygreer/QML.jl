# MUST disable threading in Qt
ENV["QSG_RENDER_LOOP"] = "basic"

using QML
using GLVisualize, GeometryTypes, GLAbstraction, Colors

function render(t)
  #timesignal = bounce(linspace(0.0, 1.0, 360))
  const N = 2048
  function spiral(i, start_radius, offset)
      Point2f0(sin(i), cos(i)) * (start_radius + ((i/2pi)*offset))
  end

  # 2D particles
  curve_data(i, N) = Point2f0[spiral(i+x/20f0, 1, (i/20)+1) for x=1:N]

  # t = const_lift(x-> (1f0-x)*100f0, timesignal)
  color = map(RGBA{Float32}, colormap("Blues", N))
  #view(visualize(const_lift(curve_data, t, N), :lines, color=color))
  visualize(const_lift(curve_data, t, N), :lines, color=color)

  #renderloop(window)
end

@qmlapp joinpath(dirname(@__FILE__), "qml", "glvisualize.qml")
exec()