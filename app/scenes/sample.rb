#
# Scene dedicated to sample work
#
class Scene::Sample < Scene
  # TODO include
  # module Concern::SoundBox
  attr_gtk
  NAME = :sample

  def initialize args
    # TODO initialize @sound
    # @sound           = SfxPlayer.new args, @mod, :my_audio
  end

  def tick
    switch_space if args.inputs.keyboard.key_down.c
  end

  def switch_space
    args.state.next_scene = :title
  end

  private

  def scene_quit
    args.state.action = false
  end

  #
  # TODO move to sound scene
  #
  def show_text
    sound_info = []
    sound_info <<  ""
    sound_info <<  "finetune:      #{@sound.sample.finetune}      num:    #{@sound.sample.num}"
    sound_info <<  "volume:        #{@sound.sample.volume}     name:   #{@sound.sample.name}"
    sound_info <<  "repeat_point:  #{@sound.sample.repeat_point}      length: #{@sound.sample.length}"
    sound_info <<  "repeat_length: #{@sound.sample.repeat_length}"
    data = @sound.sample.data[0, 20]
    if data.length == 0
      sound_info <<  "data: []"
    else
      sound_info <<  "data: #{@sound.sample.data.size}  [#{data.join(',')}..."
    end
    sound_info.each_with_index do |info, index|
      args.outputs.labels << args.layout.rect(row: 1 + index, col: 1)
        .merge(text: info, vertical_alignment_enum: 1, alignment_enum: 0,
               size_enum: 8)
    end
    args.outputs.labels << args.layout.rect(row: 8, col: 1)
      .merge(text: "sample_rate: #{@sound.sample_rate} custom rate: #{@sound.custom_rate}",
             vertical_alignment_enum: 1, alignment_enum: 0,
             size_enum: 8)
    count = @sound.sample_count
    args.outputs.labels << args.layout.rect(row: 9, col: 1)
      .merge(text: "duration:    #{@sound.custom_duration.to_i}/#{count}",
             vertical_alignment_enum: 1, alignment_enum: 0,
             size_enum: 8)
  end
end
