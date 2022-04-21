//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './SVG.sol';
import './Utils.sol';
import './Dates.sol';

library renderer {
    uint256 private constant LINE_LIMIT = 46;
    uint256 private constant MAX_LINES = 5;

    function render(
        string memory to,
        string memory from,
        LetterData memory data
    ) internal view returns (string memory) {
        uint256 numberOfLines = (bytes(data.message).length / LINE_LIMIT) + 1;
        if (numberOfLines > MAX_LINES) {
            numberOfLines = MAX_LINES;
        }

        string memory lines;

        for (uint256 i = 0; i < MAX_LINES; i++) {
            string memory text;
            text = numberOfLines > i ? utils.smartSlice(data.message, 1 + (i * LINE_LIMIT), LINE_LIMIT * (i + 1)) : '';
            lines = string.concat(
                lines,
                svg.text(
                    string.concat(
                        svg.prop('x', '24'),
                        svg.prop('y', utils.uint2str(108 + (28 * i))),
                        svg.prop('fill', data.textColor)
                    ),
                    text
                )
            );
        }

        return
            string.concat(
                string.concat(
                    '<svg xmlns="http://www.w3.org/2000/svg" width="512" height="384" style="background:',
                    data.bgColor,
                    '; color:',
                    data.textColor,
                    '; font-size: 22',
                    '">'
                ),
                svg.text(
                    string.concat(
                        svg.prop('x', '488'),
                        svg.prop('y', '32'),
                        svg.prop('font-size', '16'),
                        svg.prop('text-anchor', 'end'),
                        svg.prop('fill', data.textColor)
                    ),
                    string.concat(dates.getFormattedDate(block.timestamp))
                ),
                svg.text(
                    string.concat(svg.prop('x', '24'), svg.prop('y', '64'), svg.prop('fill', data.textColor)),
                    string.concat('gm ', utils.slice(to, 1, 6), '...', utils.slice(to, 39, 42), ',')
                ),
                lines,
                svg.text(
                    string.concat(
                        svg.prop('x', '24'),
                        svg.prop('y', utils.uint2str(124 + (28 * numberOfLines))),
                        svg.prop('fill', data.textColor)
                    ),
                    'wagmi,'
                ),
                svg.text(
                    string.concat(
                        svg.prop('x', '24'),
                        svg.prop('y', utils.uint2str(152 + (28 * numberOfLines))),
                        svg.prop('fill', data.textColor)
                    ),
                    string.concat(
                        utils.slice(utils.toString(abi.encodePacked(from)), 1, 6),
                        '...',
                        utils.slice(utils.toString(abi.encodePacked(from)), 39, 42)
                    )
                ),
                '</svg>'
            );
    }
}
