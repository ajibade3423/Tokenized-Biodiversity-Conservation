# Tokenized Biodiversity Conservation

A blockchain-based system for transparent and efficient biodiversity conservation management using Clarity smart contracts on the Stacks blockchain.

## Overview

This project implements a set of smart contracts that work together to create a comprehensive system for tokenized biodiversity conservation. The system enables tracking and verification of protected habitats, monitoring species populations, managing conservation initiatives, allocating funding, and measuring conservation impact.

## Smart Contracts

### 1. Habitat Verification Contract

The Habitat Verification Contract validates and tracks protected habitat areas.

**Key Functions:**
- `register-habitat`: Register a new habitat area with metadata
- `verify-habitat`: Verify a habitat by an authorized verifier
- `get-habitat`: Retrieve habitat details
- `get-habitat-count`: Get the total number of registered habitats

### 2. Species Tracking Contract

The Species Tracking Contract records and tracks species population data.

**Key Functions:**
- `register-species`: Register a new species with conservation status
- `add-population-record`: Add a new population count record
- `get-species`: Retrieve species details
- `get-population-record`: Get a specific population record

### 3. Conservation Initiative Contract

The Conservation Initiative Contract manages conservation projects and their milestones.

**Key Functions:**
- `create-initiative`: Create a new conservation initiative
- `add-milestone`: Add a milestone to an initiative
- `complete-milestone`: Mark a milestone as completed
- `update-initiative-status`: Update the status of an initiative

### 4. Funding Allocation Contract

The Funding Allocation Contract manages and distributes funding to conservation projects.

**Key Functions:**
- `create-funding-pool`: Create a new funding pool
- `allocate-funds`: Allocate funds from a pool to an initiative
- `update-allocation-status`: Update the status of a funding allocation
- `get-funding-pool`: Get details about a funding pool

### 5. Impact Measurement Contract

The Impact Measurement Contract tracks and measures conservation outcomes.

**Key Functions:**
- `create-impact-metric`: Define a new impact metric
- `record-measurement`: Record a measurement for an initiative
- `get-initiative-measurements`: Get all measurements for an initiative
- `get-impact-metric`: Get details about an impact metric

## System Architecture

The contracts work together to form a complete ecosystem:

1. Habitats are registered and verified in the Habitat Verification Contract
2. Species within those habitats are tracked in the Species Tracking Contract
3. Conservation initiatives targeting specific habitats are managed in the Conservation Initiative Contract
4. Funding for these initiatives is allocated through the Funding Allocation Contract
5. The impact of conservation efforts is measured using the Impact Measurement Contract

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Clarity development environment
- [Stacks CLI](https://github.com/blockstack/stacks.js) - For interacting with the Stacks blockchain

### Installation

1. Clone the repository:
   \`\`\`
   git clone https://github.com/yourusername/tokenized-biodiversity-conservation.git
   cd tokenized-biodiversity-conservation
   \`\`\`

2. Install dependencies:
   \`\`\`
   npm install
   \`\`\`

3. Run tests:
   \`\`\`
   npm test
   \`\`\`

### Deployment

To deploy the contracts to the Stacks blockchain:

1. Configure your Stacks wallet in the deployment settings
2. Deploy using Clarinet:
   \`\`\`
   clarinet deploy
   \`\`\`

## Usage Examples

### Registering a Habitat

```clarity
(contract-call? .habitat-verification register-habitat "Amazon Rainforest" "Brazil" u1000000)
