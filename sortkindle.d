//written by: github/return5
//released under MIT license 
//program which takes text file containing clippings from amazon kindle and seperates each clipping into a text file for the book which it came from

import std.stdio;
import std.file;
import std.string;
import std.regex;
import std.range;

void main(string[] args) {
	assert(args[1].isFile); //check if args[1] is a valid file.
	File[string] files;  //associative array of files
	string clipping = readText(args[1]); //clipping file to be read
	auto entire_patt = ctRegex!r"(.+\n+)+?[=+]+";  //gets entire clipping
	auto title_patt = ctRegex!r"(.*[\(.*\)])(?=\n- Highlight)"; //matches title
	auto clip_patt = ctRegex!r"(?<=[AM|PM]\n\s*\n*)(.*\s*\n+)+?(?=[=+])"; //matches clipping
	auto loc_patt = ctRegex!r"- Highlight Loc.\s+\d+\s*"; //matches location number.

	//go through text file and get text which matches eniter_part regex 
	foreach(line;matchAll(clipping, entire_patt)) { 	
		if(line) { //found a match
			auto title_match = matchFirst(line.hit,title_patt); //get title
			auto clip_match = matchFirst(line.hit,clip_patt); //get clippiing
			auto loc_match = matchFirst(line.hit,loc_patt);  //get loc.
			if(title_match && clip_match && loc_match) { //if all three were matched successfully 
				string title = strip(title_match.hit); //strip unneeded whitespace and stroe as string
				string clip = strip(clip_match.hit);
				string location = strip(loc_match.hit);
				if((title in files) == null) { //if file doesnt exist for the title, create one in files array
					files[title] = File(title ~ "_clippings.txt","w");
				}
				files[title].writeln("\n",'='.repeat(12),"\n",clip);  //write to file
				files[title].write("\n\t ",location);
			}
		}
	}
}
