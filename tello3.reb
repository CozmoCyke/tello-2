Rebol [
	date: 28-April-2018
	title: "simple interactive tello client"
    file: %tello3.reb
    author: "Graham Chiu"
    version: 0.0.1
    notes: {needs a build greater or equal to 21-Apr-2018/7:48:40}
]

attempt [close tello]

tello: open [
    scheme: 'udp
    host: 192.168.10.1
    port-id: 8889
    local-id: 9000

    awake: function [evt] [
        event: evt/type
        port: evt/port
        switch event [
            wrote [
                read port
            ]
            read [
                ; print "looking at port data"
                data: copy port/data
                clear port/data
                attempt [dump to string! data]
                attempt [print to string! data]
            ]
            error [
                close port
                return true
            ]
        ]
        false
    ]
]

tell: func [c [string!]][
    write tello to binary! dump c c
    read tello
    ; process any waiting events and then return
    wait .1
]

open tello
read tello

; put tello into command mode
tell "command"

; enter loop waiting for keyboard commands, quit on command "quit"""
forever [
    prin "tello/> "
    msg: input 
    if #"^M" = last msg [
        ; but in ren-c for windows adds a ^M at the end of input
        take/last msg
    ]
    dump msg
    if msg = "quit" [break]
    if not empty? msg [
        tell msg
    ]
]

close tello

halt
