<?php

add_filter(
    'http_request_args',
    function (array $args, string $url) {
        // @todo condition on URL(s)
        $args['reject_unsafe_urls'] = false;
        return $args;
    },
    10,
    2
);
