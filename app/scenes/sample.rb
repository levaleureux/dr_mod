#
# Sample scene: displays sample properties (finetune, volume, etc.)
# and waveform visualization. Allows audio playback and navigation
# between samples via SoundBox concern.
#
# Keys: see Concern::SoundBox for playback controls, C to go back.
#
class Scene::Sample < Scene
  include ::Concern::SoundBox
  attr_gtk
  NAME = :sample

  def initialize args
  end

  def tick
    switch_space if args.inputs.keyboard.key_down.c
    activate_scene unless args.state.action
    @sound = args.state.current_samples
    show_text
    sound_section
  end

  def switch_space
    args.state.next_scene = :title
  end

  private

  def activate_scene
    args.state.action = true
  end

  def scene_quit
    args.state.action = false
  end

  def show_text
    draw_sample_labels
    draw_rate_label
    draw_note_label
  end

  def draw_sample_labels
    build_sample_info.each_with_index do |info, index|
      args.outputs.labels << args.layout.rect(row: 1 + index, col: 1)
        .merge(text: info, vertical_alignment_enum: 1,
               alignment_enum: 0, size_enum: 8)
    end
  end

  def build_sample_info
    s = @sound.sample
    ["", *sample_properties(s), data_summary]
  end

  def sample_properties s
    [ "finetune:      #{s.finetune}      num:    #{s.num}",
      "volume:        #{s.volume}     name:   #{s.name}",
      "repeat_point:  #{s.repeat_point}      length: #{s.length}",
      "repeat_length: #{s.repeat_length}" ]
  end

  def data_summary
    data = @sound.sample.data[0, 20]
    return "data: []" if data.empty?
    "data: #{@sound.sample.data.size}  [#{data.join(',')}..."
  end

  def draw_rate_label
    args.outputs.labels << args.layout.rect(row: 8, col: 1)
      .merge(text: "sample_rate: #{@sound.sample_rate} custom rate: #{@sound.custom_rate}",
             vertical_alignment_enum: 1, alignment_enum: 0,
             size_enum: 8)
  end

  def draw_note_label
    args.outputs.labels << args.layout.rect(row: 9, col: 1)
      .merge(text: "note:    #{@note_name}",
             vertical_alignment_enum: 1, alignment_enum: 0,
             size_enum: 8)
  end
end
