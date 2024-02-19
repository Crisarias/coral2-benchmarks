//////////////////////////////////////////////////////////////////////////////////////
// This file is distributed under the University of Illinois/NCSA Open Source License.
// See LICENSE file in top directory for details.
//
// Copyright (c) 2016 Jeongnim Kim and QMCPACK developers.
//
// File developed by: Jeremy McMinnis, jmcminis@gmail.com, University of Illinois at Urbana-Champaign
//
// File created by: Jeremy McMinnis, jmcminis@gmail.com, University of Illinois at Urbana-Champaign
//////////////////////////////////////////////////////////////////////////////////////
    
    


#ifndef QMCPLUSPLUS_EE_FACTORY_H
#define QMCPLUSPLUS_EE_FACTORY_H
#include "QMCDrivers/QMCDriver.h"

namespace qmcplusplus
{
class ParticleSetPool;
class HamiltonianPool;

struct EEFactory
{
  int VMCMode;
  xmlNodePtr myNode;
  EEFactory(int vmode, xmlNodePtr cur):VMCMode(vmode), myNode(cur) {}
  QMCDriver* create(MCWalkerConfiguration& w, TrialWaveFunction& psi, QMCHamiltonian& h,
                    ParticleSetPool& ptclpool, HamiltonianPool& hpool, WaveFunctionPool& ppool);
};
}

#endif