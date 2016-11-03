#!/bin/bash

ARGS=""
if [[ -n "$JITSI_SECRET" ]]; then
	ARGS="$ARGS --secret=$JITSI_SECRET"
fi

if [[ -n "$JITSI_DOMAIN" ]]; then
	ARGS="$ARGS --domain=$JITSI_DOMAIN"
fi

if [[ -n "$JITSI_HOST" ]]; then
	ARGS="$ARGS --host=$JITSI_HOST"
fi

/usr/share/jitsi-videobridge/jvb.sh $ARGS
