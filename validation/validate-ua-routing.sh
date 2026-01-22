#!/usr/bin/env bash

echo "Android request:"
curl -s -H "User-Agent: Android" http://localhost:8080/app
echo -e "\n"

echo "iOS request:"
curl -s -H "User-Agent: iPhone" http://localhost:8080/app
echo -e "\n"

echo "No User-Agent (fallback):"
curl -s http://localhost:8080/app
echo
