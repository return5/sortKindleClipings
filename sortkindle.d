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

string getTitle(string title, string clip) {
    if(clip.split(regex(" +")).length == 1) {
        return title ~ "_defs.txt";
    }
    else {
        return title ~ "_clip.txt";
    }
}

void main(string[] args) {
	File[string] files;                                                 //associative array of files
	string clipping       = readText(args[1]);                         //clipping file to be read
    auto entire_part      = ctRegex!r"(.+[\r*|\n*]+)+?(==========)";  //gets entire clipping
	auto title_part       = ctRegex!r"(.+)(\r|\n)*(- Highlight)";    //matches title
	auto loc_part         = ctRegex!r"- Highlight Loc.\s+\d+\s*";  //matches location number.

	//go through text file and get text which matches entire_part regex 
	foreach(line; matchAll(clipping,entire_part)) { 	
		if(line) { //found a match
			auto title_match = matchFirst(line.captures[0],title_part);      //get title
			auto clip_match  = strip(line.captures[1]);                     //get clippiing
			auto loc_match   = matchFirst(line.captures[0],loc_part);      //get loc.
			if(title_match && clip_match && loc_match) {                  //if all three were matched successfully
                string title     = getTitle(title_match.hit,clip_match);
				string clip      = strip(clip_match);
				string location  = strip(loc_match.hit);
                if((title in files) == null) {                   //if file doesnt exist for the title, create one in files array
					files[title] = File(title,"w");
				}
				else {
					files[title].writeln("\n",'='.repeat(12),"\n");  //write to file
               	}
               	files[title].write(clip,"\n\t ",location);
			}
		}
	}
}
