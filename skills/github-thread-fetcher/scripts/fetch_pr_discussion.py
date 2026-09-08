#!/usr/bin/env python3
"""Fetch every GitHub pull-request discussion connection through gh GraphQL."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from typing import Any


def graphql(query: str, variables: dict[str, Any]) -> dict[str, Any]:
    command = ["gh", "api", "graphql", "-f", f"query={query}"]
    for name, value in variables.items():
        if value is None:
            continue
        command.extend(["-F", f"{name}={value}"])
    result = subprocess.run(command, text=True, capture_output=True)
    if result.returncode:
        raise RuntimeError((result.stderr or result.stdout).strip() or "gh api graphql failed")
    data = json.loads(result.stdout)
    if data.get("errors"):
        raise RuntimeError(json.dumps(data["errors"], ensure_ascii=False))
    return data["data"]


def paginate(query: str, variables: dict[str, Any], path: tuple[str, ...]) -> list[dict[str, Any]]:
    nodes: list[dict[str, Any]] = []
    cursor: str | None = None
    while True:
        data = graphql(query, {**variables, "cursor": cursor})
        connection: Any = data
        for key in path:
            if not isinstance(connection, dict) or connection.get(key) is None:
                raise RuntimeError("Pull request not found or not accessible.")
            connection = connection[key]
        nodes.extend(connection["nodes"])
        if not connection["pageInfo"]["hasNextPage"]:
            return nodes
        cursor = connection["pageInfo"]["endCursor"]


PR_COMMENTS = """
query($owner: String!, $repo: String!, $number: Int!, $cursor: String) {
  repository(owner: $owner, name: $repo) { pullRequest(number: $number) {
    comments(first: 100, after: $cursor) {
      nodes { author { login } body createdAt url }
      pageInfo { hasNextPage endCursor }
    }
  } }
}"""

THREADS = """
query($owner: String!, $repo: String!, $number: Int!, $cursor: String) {
  repository(owner: $owner, name: $repo) { pullRequest(number: $number) {
    reviewThreads(first: 100, after: $cursor) {
      nodes { id isResolved isOutdated path line originalLine }
      pageInfo { hasNextPage endCursor }
    }
  } }
}"""

THREAD_COMMENTS = """
query($id: ID!, $cursor: String) { node(id: $id) { ... on PullRequestReviewThread {
  comments(first: 100, after: $cursor) {
    nodes { author { login } body createdAt url }
    pageInfo { hasNextPage endCursor }
  }
} } }
"""

CLOSING_ISSUES = """
query($owner: String!, $repo: String!, $number: Int!, $cursor: String) {
  repository(owner: $owner, name: $repo) { pullRequest(number: $number) {
    closingIssuesReferences(first: 100, after: $cursor) {
      nodes { number title url state }
      pageInfo { hasNextPage endCursor }
    }
  } }
}"""


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", required=True, metavar="OWNER/REPO")
    parser.add_argument("--pr", required=True, type=int)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        parts = args.repo.split("/")
        if len(parts) != 2 or not all(parts):
            raise ValueError
        owner, repo = parts
    except ValueError:
        print("--repo must be OWNER/REPO", file=sys.stderr)
        return 2

    variables = {"owner": owner, "repo": repo, "number": args.pr}
    try:
        threads = paginate(THREADS, variables, ("repository", "pullRequest", "reviewThreads"))
        for thread in threads:
            thread["comments"] = paginate(THREAD_COMMENTS, {"id": thread["id"]}, ("node", "comments"))
        result = {
            "comments": paginate(PR_COMMENTS, variables, ("repository", "pullRequest", "comments")),
            "reviewThreads": threads,
            "closingIssues": paginate(CLOSING_ISSUES, variables, ("repository", "pullRequest", "closingIssuesReferences")),
        }
    except RuntimeError as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
