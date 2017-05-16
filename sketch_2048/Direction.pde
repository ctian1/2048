// You are not allowed to change this file.
//
// An enum is useful for providing symbols to describe things.
// In this case we want a way to refer to directions and compass
// directions such as WEST, NORTH, EAST, and SOUTH are a lot nicer
// than numbers where you have to remember what each number means.
//
// It's another way of doing abstraction.
//
// If you are curious as to the details of enum, I'll leave it to you
// to look it up.  For now, it isn't critical to do so because the
// big point of an abstraction is that we don't have to worry about
// the implementation details.
//
// ALL_CAPS are used because these things are constants.
//
// To use a symbol: DIR.WEST, DIR.NORTH, etc.

enum DIR { WEST, NORTH, EAST, SOUTH };