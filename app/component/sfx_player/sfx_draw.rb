#
# Waveform rendering for SfxPlayer.
# Draws sample waveform on a render target
# and displays rate/sample info labels.
#
module SfxDraw

  private

  def draw_rate_label
    args.outputs.labels << args.layout.rect(row: 10, col: 1)
      .merge(text: "sample_rate: >> #{@sample_rate} <<",
             vertical_alignment_enum: 1, alignment_enum: 0,
             size_enum: 8)
  end

  def init_draw args
    @wave_data = sample.normalized_data
    draw_waveform args, @wave_data
    @done = true
  end

  def draw_waveform args, wave_data
    wf = args.render_target(:waveform)
    wf.background_color = [100, 100, 100]
    draw_wave_segments wf, wave_data
  end

  # Draw each segment of the waveform.
  def draw_wave_segments wf, wave_data
    compute_wf_dimensions wf, wave_data
    wave_data.each_cons(2).with_index do |(y1, y2), i|
      wf.lines << wave_line(y1, y2, i)
    end
  end

  # Compute waveform geometry dimensions.
  # Stored as ivars to avoid passing them to wave_line.
  def compute_wf_dimensions wf, wave_data
    @wf_step      = wf.width / (wave_data.length - 1)
    @wf_center_y  = wf.height / 1.5
    @wf_amplitude = wf.height / 6
  end

  # Build a single waveform line segment [x1, y1, x2, y2, r, g, b].
  # Converts normalized sample values (0..1) to pixel coordinates
  # centered on @wf_center_y with @wf_amplitude scaling.
  def wave_line y1, y2, i
    [ @wf_step * i, wf_y(y1),
      @wf_step * (i + 1), wf_y(y2),
      255, 255, 0 ]
  end

  # Convert a normalized sample value to a Y pixel coordinate.
  def wf_y val
    @wf_center_y + (val * @wf_amplitude) * 2 - @wf_amplitude
  end

  def tick_draw args
    init_draw(args) unless @done
    args.outputs.sprites << {
      x: 70, y: 550, w: 1040, h: 100, path: :waveform
    }
  end
end
