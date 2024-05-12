require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xff_808080)
BOTTOM_COLOR = Gosu::Color::WHITE
ARTWORK_WIDTH = 200

module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

# Put your record definitions here

class Album
    attr_accessor :artist, :title, :tracks, :artwork

    def initialize(artist, title, tracks, artwork)
		@artist = artist
        @title = title
        @tracks = tracks
		@artwork = artwork
    end
end

class Track
    attr_accessor :name, :location

    def initialize(n, l)
        @name = n
        @location = l
    end
end

def read_music_track(a_file)
    track_name = a_file.gets.chomp
    track_location = a_file.gets.chomp
    return Track.new(track_name, track_location)
end

def read_music_tracks(a_file)
    tracks = []
    index = 0

    count = a_file.gets.to_i
    while index < count
        tracks << read_music_track(a_file)
        index += 1
    end
    return tracks
end

def get_album(a_file)
    title = a_file.gets.chomp
    artist = a_file.gets.chomp
	artwork = a_file.gets.chomp
    tracks = read_music_tracks(a_file)
    return Album.new(artist, title, tracks, artwork)
end

def get_albums(file_name)
    albums = []
    a_file = File.new(file_name, 'r')
	count = a_file.gets.to_i

    index = 0
    while index < count
        albums << get_album(a_file)
        index += 1
    end

    a_file.close
    return albums
end

def read_artwork(albums)
	artworks = []
	i = 0
	while i < albums.length
		artwork = albums[i].artwork
		artworks << Gosu::Image.new(artwork)
		i+=1
	end
	return artworks
end


class MusicPlayerMain < Gosu::Window

	def initialize
	    super 806, 500
	    self.caption = "Music Player"

		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
		@albums = get_albums('albums.txt')
		@artworks = read_artwork(@albums)

        @font = Gosu::Font.new(18)
		@track_font = Gosu::Font.new(25)

		@chose_song = 0
		@chose_album = 0
		@song = nil
		
		@another_song = false
	end

	def draw_albums()
		# Draw album artworks
		@artworks[0].draw(32, 22, ZOrder::TOP)
		@artworks[1].draw(288, 22, ZOrder::TOP)
		@artworks[2].draw(32, 267, ZOrder::TOP)
		@artworks[3].draw(288, 267, ZOrder::TOP)
	  
		# Draw album titles
		color = Gosu::Color::WHITE
		chose_color = Gosu::Color::BLACK

		if @chose_album == 0
			@font.draw_text(@albums[0].title, 100, 235, ZOrder::TOP, 1.0, 1.0, chose_color)
		else
			@font.draw_text(@albums[0].title, 100, 235, ZOrder::TOP, 1.0, 1.0, color)
		end

		if @chose_album == 1
			@font.draw_text(@albums[1].title, 365, 235, ZOrder::TOP, 1.0, 1.0, chose_color)
		else
			@font.draw_text(@albums[1].title, 365, 235, ZOrder::TOP, 1.0, 1.0, color)
		end

		if @chose_album == 2
			@font.draw_text(@albums[2].title, 100, 475, ZOrder::TOP, 1.0, 1.0, chose_color)
		else
			@font.draw_text(@albums[2].title, 100, 475, ZOrder::TOP, 1.0, 1.0, color)
		end

		if @chose_album == 3
			@font.draw_text(@albums[3].title, 375, 475, ZOrder::TOP, 1.0, 1.0, chose_color)
		else
			@font.draw_text(@albums[3].title, 375, 475, ZOrder::TOP, 1.0, 1.0, color)
		end

	end

	def draw_tracks
		# use while loop
		i = 0
		while i < @albums[@chose_album].tracks.length
			if i == @chose_song
				@track_font.draw_text(@albums[@chose_album].tracks[i].name, 520, 42 + i * 50, ZOrder::TOP, 1.0, 1.0, Gosu::Color::BLACK)
			else
				@track_font.draw_text(@albums[@chose_album].tracks[i].name, 520, 42 + i * 50, ZOrder::TOP, 1.0, 1.0, Gosu::Color::GRAY)
			end
			i += 1
		end
	end

			

  # Takes a track index and an Album and plays the Track from the Album

  def playTrack(track, album)
  	 # complete the missing code
	if @another_song
		@song = Gosu::Song.new(album.tracks[track].location)
		@song.play(false)
		@another_song = false
	end
  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
		Gosu.draw_rect(0, 0, 801, 500, TOP_COLOR, ZOrder::BACKGROUND, mode=:default)
		Gosu.draw_rect(490, 0, 801, 500, BOTTOM_COLOR, ZOrder::BACKGROUND, mode=:default)
	end

# Not used? Everything depends on mouse actions.

	def update
		playTrack(@chose_song, @albums[@chose_album])
	end

 # Draws the album images and the track list for the selected album

	def draw
		# Complete the missing code
		draw_background
		draw_albums()
		draw_tracks()
	end

 	def needs_cursor?; true; end

	# If the button area (rectangle) has been clicked on change the background color
	# also store the mouse_x and mouse_y attributes that we 'inherit' from Gosu
	# you will learn about inheritance in the OOP unit - for now just accept that
	# these are available and filled with the latest x and y locations of the mouse click.

	def button_down(id)

		case id
	    when Gosu::MsLeft
			if mouse_x.between?(32, 32 + 200) and mouse_y.between?(22, 22 + 200)
				@chose_album = 0
				@chose_song = 0
				@another_song = true
			elsif mouse_x.between?(288, 288 + 200) and mouse_y.between?(22, 22 + 200)
				@chose_album = 1
				@chose_song = 0
				@another_song = true
			elsif mouse_x.between?(32, 32 + 200) and mouse_y.between?(267, 267 + 200)
				@chose_album = 2
				@chose_song = 0
				@another_song = true
			elsif mouse_x.between?(288, 288 + 200) and mouse_y.between?(267, 267 + 200)
				@chose_album = 3
				@chose_song = 0
				@another_song = true
			end

			# Choose track
			i = 0
			while i < @albums[@chose_album].tracks.length
				if mouse_x.between?(520, 520 + 200) and mouse_y.between?(42 + i * 50, 42 + i * 50 + 50)
					@chose_song = i
					@another_song = true
				end
				i += 1
			end
		end
	end
end


# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0
