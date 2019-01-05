/** @function displayCurrentPlayer
 *
 * @param myPlayerNumber
 * @param playerNumber
 */
var displayCurrentPlayer = function (myPlayerNumber, playerNumber) {
    if (myPlayerNumber === playerNumber) {
        $('#current-player').text('It\'s your move...')
    } else {
        $('#current-player').text('Player ' + (playerNumber + 1) + '\'s Move...')
    }
};


/** @function displayNotMyMove
 *
 */
var displayNotMyMove = function (){
    alert('It\'s not your move! Please wait until the other player has moved :)');
}


/** @function displayInValidMove
 *
 * @param player
 */
var displayInValidMove = function (player) {
    alert('You cannot make that move. Please try another!');
};


/** @function displayDraw
 *
 */
var displayDraw = function () {
    alert('Draw! No winner. Play again.');
    displayNewGameButton();
}


/** @function displayWin
 *
 * @param myPlayerNumber
 * @param winningPlayerNumber
 */
var displayWin = function (myPlayerNumber, winningPlayerNumber) {
    if (myPlayerNumber === winningPlayerNumber) {
        alert('You\'ve won the game!');
    } else {
        alert('Player ' + (winningPlayerNumber + 1) + ' has won the game. Better luck next time :)');
    }
    displayNewGameButton();
};


/** @function displayNewGameButton
 *
 */
var displayNewGameButton = function () {
    $('#start-new-game-button').css('display', 'block');
}


/** @function displayMove
 *
 * @param {bitBoard} - The Bitboard's 64 bit binary string
 *
 *
 * Bitboard Grid Layout:
 *
 *   6 13 20 27 34 41 48   55 62     Additional row
 * +---------------------+
 * | 5 12 19 26 33 40 47 | 54 61     top row
 * | 4 11 18 25 32 39 46 | 53 60
 * | 3 10 17 24 31 38 45 | 52 59
 * | 2  9 16 23 30 37 44 | 51 58
 * | 1  8 15 22 29 36 43 | 50 57
 * | 0  7 14 21 28 35 42 | 49 56 63  bottom row
 * +---------------------+
 *
 * Bitboard overview, with pseudo-code, and the above grid layout defined here:
 * https://github.com/denkspuren/BitboardC4/blob/master/BitboardDesign.md
 *
 *
 * Bitboard (64 bit binary string):
 *
 * 0 0000000 0000000 0000000 0000000 0000000 0000000 0000000 0010000 0000000
 *     - MSB's -      col 6   col 5   col 4   col 3   col 2   col 1   col 0
 *
 * This Bitboard has 1 position taken on the game grid at row 4, col 1.
 *
 * How?
 *
 * Column 1 from the Bitboard above is "0010000". So we of course
 * know which column we are on. We start our row count from the Least
 * Significant Bit (LSB). Least Significant Bit (LSB) to Most
 * Significant Bit (MSB) is read from right to left. To illustrate,
 * Column 1 is displayed vertically (below) with each row defined:
 *
 * 0 (MSB)  row 6
 * 0        row 5
 * 1        row 4
 * 0        row 3
 * 0        row 2
 * 0        row 1
 * 0 (LSB)  row 0
 *
 *
 * NOTE: A great upgrade to this function would be to simply
 *       use the Javascript Bitwise operators to extract the
 *       positions from the Bitboards Binary String and create
 *       a game grid that simply assigns to those positions.
 *       
 */
var displayMove = function (player, bitBoard) {

    // Set the players color
    if (player == 0) {
        var playerColor = 'red';
    } else {
        var playerColor = 'yellow';
    }

    // Convert String to Json Object
    var bitBoardParsed = JSON.parse(bitBoard);

    // Loop fixed columns
    for (var col = 0; col <= 6; ++col) {

        // Convert String of rows into Array of rows.
        var rows = bitBoardParsed[col].split('');

        // Loop fixed rows
        for (var row = 0; row <= 5; ++row) {
            if (rows[row] == 1) {
                $('.row-' + row + '-col-' + col).css('background-color', playerColor);
            }
        }

    }
};


/** @function addEventListener - ajax:success
 *
 * @param {event} - Event contains server response details
 *
 */
document.body.addEventListener('ajax:success', function (event) {
    var detail = event.detail;
    var data = detail[0]; //, status = detail[1], xhr = detail[2];
    console.log('data: ' + data);
});

