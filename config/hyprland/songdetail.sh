#!/usr/bin/env bash

song_info=$(playerctl --player=spotify metadata --format '  {{title}} - {{artist}}')
echo "$song_info" 
