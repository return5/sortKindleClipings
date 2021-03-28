
//written by: github/return5
//released under MIT license 
//program which takes text file containing clippings from amazon kindle and seperates each clipping into a text file for the book which it came from.
//seperates single words from multi words.  single words are assumed to be words to look up/save definition of. these are saved in file with post-fix "_def.txt"
//lines with more than one word are savged in text file with post-fix "_clip.txt"

import std.stdio;
import std.file;
import std.string;
import std.regex;
import std.range;

string getTitle(immutable string title,immutable string clip) {
    immutable auto remove      = ctRegex!("[\n|\r|\"|:|\']*","g");    //match to remove these chars from title
    immutable string new_title = replaceAll(strip(title,"\357\273\277"),remove,"");
    if(clip.split(regex(" +")).length == 1) {
        return new_title ~ "_defs.txt";
    }
    else {
        return new_title ~ "_clip.txt";
    }
}

void main(string[] args) {
	immutable string clipping       = readText(args[1]);                         //clipping file to be read
    immutable auto entire_part      = ctRegex!r"(.+[\r*|\n*]+)+?(==========)";  //gets entire clipping
	immutable auto title_part       = ctRegex!r"(.+)(\r|\n)*(- Highlight)";    //matches title
	immutable auto loc_part         = ctRegex!r" (Loc\.\s+\d+-?\d*)\s+\|";   //matches location number.

	//go through text file and get text which matches entire_part regex 
	foreach(line; matchAll(clipping,entire_part)) { 	
        //found a match
		if(line) { 
		    immutable string title_match = matchFirst(line.captures[0],title_part)[1];      //get title
		    immutable string clip_match  = strip(line.captures[1]);                     //get clippiing
			immutable string loc_match   = matchFirst(line.captures[0],loc_part)[1];      //get loc.
			if(title_match && clip_match && loc_match) {                  //if all three were matched successfully
                immutable string title    = getTitle(title_match,clip_match);
				immutable string clip     = strip(clip_match);
				immutable string location = strip(loc_match);
                writeln("title is: ", title);
                writeln("clip is: ",clip);
                writeln("location is ", location);
			}
		}
	}
}
